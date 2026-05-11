use axum::{
    extract::{Request, State},
    http::header,
    middleware::Next,
    response::Response,
};
use sqlx::{Pool, Sqlite};
use std::sync::Arc;

use crate::{
    AppState,
    error::AppError,
    utils::decode_access_token,
};

#[derive(Clone, Debug)]
pub struct CurrentUser {
    pub user_id: String,
    pub email: String,
    pub full_name: String,
    pub role: UserRole,
    pub branch_id: Option<String>,
}

#[derive(Clone, Debug, PartialEq)]
pub enum UserRole {
    Owner,
    KepalaCabang,
    PicPelaporan,
    Admin,
    Sales,
    Driver,
    Teknisi,
    Gudang,
    Kasir,
    Marketing,
    CS,
}

impl UserRole {
    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "owner" => Some(UserRole::Owner),
            "kepala_cabang" => Some(UserRole::KepalaCabang),
            "pic_pelaporan" => Some(UserRole::PicPelaporan),
            "picpelaporan" => Some(UserRole::PicPelaporan),
            "admin" => Some(UserRole::Admin),
            "sales" => Some(UserRole::Sales),
            "driver" => Some(UserRole::Driver),
            "teknisi" => Some(UserRole::Teknisi),
            "gudang" => Some(UserRole::Gudang),
            "kasir" => Some(UserRole::Kasir),
            "marketing" => Some(UserRole::Marketing),
            "cs" => Some(UserRole::CS),
            _ => None,
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            UserRole::Owner => "owner",
            UserRole::KepalaCabang => "kepala_cabang",
            UserRole::PicPelaporan => "pic_pelaporan",
            UserRole::Admin => "admin",
            UserRole::Sales => "sales",
            UserRole::Driver => "driver",
            UserRole::Teknisi => "teknisi",
            UserRole::Gudang => "gudang",
            UserRole::Kasir => "kasir",
            UserRole::Marketing => "marketing",
            UserRole::CS => "cs",
        }
    }

    pub fn has_permission(&self, required: &[UserRole]) -> bool {
        required.contains(self) || *self == UserRole::Owner
    }
}

/// Auth middleware - uses State extractor, compatible with AppState (not Arc<AppState>)
/// This version is used with from_fn_with_state in main.rs
pub async fn auth_middleware(
    State(state): State<Arc<AppState>>,
    mut request: Request,
    next: Next,
) -> Result<Response, AppError> {
    let auth_header = request
        .headers()
        .get(header::AUTHORIZATION)
        .and_then(|h| h.to_str().ok())
        .and_then(|h| h.strip_prefix("Bearer "))
        .map(|t| t.to_string());

    let token = match auth_header {
        Some(token) => token,
        None => return Err(AppError::Unauthorized),
    };

    let claims = decode_access_token(&token, &state.config)?;

    let user: Option<(String, String, String, Option<String>)> = sqlx::query_as(
        "SELECT id, username as email, username as full_name, branch_id FROM users WHERE id = ?1 AND is_active = 1"
    )
    .bind(&claims.sub)
    .fetch_optional(&state.pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let (user_id, email, full_name, branch_id) = match user {
        Some(u) => u,
        None => return Err(AppError::Unauthorized),
    };

    let role = UserRole::from_str(&claims.role).ok_or(AppError::Unauthorized)?;

    request.extensions_mut().insert(CurrentUser {
        user_id,
        email,
        full_name,
        role,
        branch_id,
    });

    Ok(next.run(request).await)
}

/// Stateless auth middleware - for use with from_fn (no State extractor)
/// Reads state from request extensions (injected by with_state)
pub async fn auth_middleware_stateless(
    mut request: Request,
    next: Next,
) -> Result<Response, AppError> {
    // Extract AppState from the extensions (populated by axum's with_state)
    let state = request
        .extensions()
        .get::<AppState>()
        .cloned();

    // If state not found in extensions, try reading it differently
    // For stateless middleware, we need to validate token without DB (JWT only)
    let auth_header = request
        .headers()
        .get(header::AUTHORIZATION)
        .and_then(|h| h.to_str().ok())
        .and_then(|h| h.strip_prefix("Bearer "))
        .map(|t| t.to_string());

    let token = match auth_header {
        Some(token) => token,
        None => return Err(AppError::Unauthorized),
    };

    // We need the config for JWT verification. Since we don't have State,
    // we load it from environment directly (same values as Config::from_env)
    let jwt_secret = std::env::var("JWT_SECRET")
        .map_err(|_| AppError::Unauthorized)?;

    // Manually decode JWT
    use jsonwebtoken::{decode, DecodingKey, Validation, Algorithm};
    use serde::{Deserialize, Serialize};

    #[derive(Debug, Serialize, Deserialize)]
    struct Claims {
        sub: String,
        username: String,
        role: String,
        branch_id: Option<String>,
        exp: usize,
    }

    let token_data = decode::<Claims>(
        &token,
        &DecodingKey::from_secret(jwt_secret.as_bytes()),
        &Validation::new(Algorithm::HS256),
    ).map_err(|_| AppError::Unauthorized)?;

    let claims = token_data.claims;
    let role = UserRole::from_str(&claims.role).ok_or(AppError::Unauthorized)?;

    // If we have state available, verify user is still active in DB
    if let Some(state) = state {
        let user: Option<(String, String, String, Option<String>)> = sqlx::query_as(
            "SELECT id, username as email, username as full_name, branch_id FROM users WHERE id = ?1 AND is_active = 1"
        )
        .bind(&claims.sub)
        .fetch_optional(&state.pool)
        .await
        .map_err(|e| AppError::Database(e))?;

        if user.is_none() {
            return Err(AppError::Unauthorized);
        }
    }

    request.extensions_mut().insert(CurrentUser {
        user_id: claims.sub,
        email: claims.username.clone(),
        full_name: claims.username,
        role,
        branch_id: claims.branch_id,
    });

    Ok(next.run(request).await)
}
