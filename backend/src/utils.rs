use crate::{
    config::Config,
    models::{JwtClaims, JwtRefreshClaims, RefreshToken, User},
    error::AppError,
};
use bcrypt::verify;
use chrono::{Duration, Utc};
use jsonwebtoken::{decode, encode, Algorithm, DecodingKey, EncodingKey, Header, Validation};
use rand::Rng;
use sqlx::{Pool, Sqlite};
use uuid::Uuid;

pub fn verify_password(password: &str, hash: &str) -> Result<bool, AppError> {
    verify(password, hash).map_err(|_| AppError::PasswordHash)
}

pub fn generate_access_token(user: &User, branch_name: Option<String>, config: &Config) -> Result<String, AppError> {
    let now = Utc::now();
    let exp = now + Duration::hours(config.jwt_expiry_hours);

    let claims = JwtClaims {
        sub: user.id.clone(),
        username: user.username.clone(),
        role: user.role.clone(),
        branch_id: user.branch_id.clone(),
        branch_name,
        exp: exp.timestamp() as usize,
        iat: now.timestamp() as usize,
    };

    encode(
        &Header::new(Algorithm::HS256),
        &claims,
        &EncodingKey::from_secret(config.jwt_secret.as_bytes()),
    )
    .map_err(|e| AppError::Jwt(e.to_string()))
}

pub fn generate_refresh_token(
    user_id: &str,
    token_id: &str,
    config: &Config,
) -> Result<String, AppError> {
    let now = Utc::now();
    let exp = now + Duration::days(config.refresh_token_expiry_days);

    let claims = JwtRefreshClaims {
        sub: user_id.to_string(),
        token_id: token_id.to_string(),
        exp: exp.timestamp() as usize,
        iat: now.timestamp() as usize,
    };

    encode(
        &Header::new(Algorithm::HS256),
        &claims,
        &EncodingKey::from_secret(config.jwt_secret.as_bytes()),
    )
    .map_err(|e| AppError::Jwt(e.to_string()))
}

pub fn decode_access_token(token: &str, config: &Config) -> Result<JwtClaims, AppError> {
    let validation = Validation::new(Algorithm::HS256);
    decode::<JwtClaims>(
        token,
        &DecodingKey::from_secret(config.jwt_secret.as_bytes()),
        &validation,
    )
    .map(|data| data.claims)
    .map_err(|e| AppError::Jwt(e.to_string()))
}

pub fn decode_refresh_token(token: &str, config: &Config) -> Result<JwtRefreshClaims, AppError> {
    let validation = Validation::new(Algorithm::HS256);
    decode::<JwtRefreshClaims>(
        token,
        &DecodingKey::from_secret(config.jwt_secret.as_bytes()),
        &validation,
    )
    .map(|data| data.claims)
    .map_err(|e| AppError::Jwt(e.to_string()))
}

pub async fn create_refresh_token(
    pool: &Pool<Sqlite>,
    user_id: &str,
    token: &str,
    expires_days: i64,
) -> Result<String, sqlx::Error> {
    let id = Uuid::new_v4().to_string();
    let expires_at = Utc::now() + Duration::days(expires_days);

    sqlx::query(
        r#"
        INSERT INTO refresh_tokens (id, user_id, token, expires_at)
        VALUES (?1, ?2, ?3, ?4)
        "#,
    )
    .bind(&id)
    .bind(user_id)
    .bind(token)
    .bind(&expires_at)
    .execute(pool)
    .await?;

    Ok(id)
}

pub async fn get_refresh_token(pool: &Pool<Sqlite>, token: &str) -> Result<Option<RefreshToken>, sqlx::Error> {
    sqlx::query_as::<_, RefreshToken>(
        r#"
        SELECT id, user_id, token, expires_at, created_at
        FROM refresh_tokens
        WHERE token = ?1 AND expires_at > CURRENT_TIMESTAMP
        "#,
    )
    .bind(token)
    .fetch_optional(pool)
    .await
}

pub async fn revoke_refresh_token(pool: &Pool<Sqlite>, token: &str) -> Result<(), sqlx::Error> {
    sqlx::query(
        r#"
        DELETE FROM refresh_tokens WHERE token = ?1
        "#,
    )
    .bind(token)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn revoke_all_user_refresh_tokens(pool: &Pool<Sqlite>, user_id: &str) -> Result<(), sqlx::Error> {
    sqlx::query(
        r#"
        DELETE FROM refresh_tokens WHERE user_id = ?1
        "#,
    )
    .bind(user_id)
    .execute(pool)
    .await?;
    Ok(())
}

pub fn generate_otp() -> String {
    let mut rng = rand::thread_rng();
    (0..6)
        .map(|_| rng.gen_range(0..10))
        .map(|n| n.to_string())
        .collect()
}

pub async fn create_password_reset_otp(
    pool: &Pool<Sqlite>,
    user_id: &str,
    otp: &str,
    expiry_minutes: i64,
) -> Result<String, sqlx::Error> {
    // Mark existing OTPs as used
    sqlx::query(
        r#"
        UPDATE password_reset_otps SET used = 1 WHERE user_id = ?1 AND used = 0
        "#,
    )
    .bind(user_id)
    .execute(pool)
    .await?;

    let id = Uuid::new_v4().to_string();
    let expires_at = Utc::now() + Duration::minutes(expiry_minutes);

    sqlx::query(
        r#"
        INSERT INTO password_reset_otps (id, user_id, otp, expires_at, used)
        VALUES (?1, ?2, ?3, ?4, 0)
        "#,
    )
    .bind(&id)
    .bind(user_id)
    .bind(otp)
    .bind(&expires_at)
    .execute(pool)
    .await?;

    Ok(id)
}

pub async fn verify_password_reset_otp(
    pool: &Pool<Sqlite>,
    user_id: &str,
    otp: &str,
) -> Result<bool, sqlx::Error> {
    let result = sqlx::query(
        r#"
        SELECT id FROM password_reset_otps
        WHERE user_id = ?1 AND otp = ?2 AND used = 0 AND expires_at > CURRENT_TIMESTAMP
        "#,
    )
    .bind(user_id)
    .bind(otp)
    .fetch_optional(pool)
    .await?;

    Ok(result.is_some())
}

pub async fn mark_otp_used(pool: &Pool<Sqlite>, user_id: &str, otp: &str) -> Result<(), sqlx::Error> {
    sqlx::query(
        r#"
        UPDATE password_reset_otps SET used = 1
        WHERE user_id = ?1 AND otp = ?2
        "#,
    )
    .bind(user_id)
    .bind(otp)
    .execute(pool)
    .await?;
    Ok(())
}
