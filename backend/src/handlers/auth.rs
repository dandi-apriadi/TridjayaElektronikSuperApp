use std::sync::Arc;
use axum::{
    extract::State,
    Json,
};
use bcrypt::hash;
use uuid::Uuid;

use crate::{
    AppState,
    db::{get_branch_by_id, get_user_by_username, update_user_password},
    error::{AppError, AppResult},
    models::{
        LoginRequest, LoginResponse, LogoutResponse, PasswordResetRequest,
        PasswordResetResponse, PasswordResetVerifyRequest, RefreshTokenRequest,
    },
    utils::{
        create_password_reset_otp, create_refresh_token, decode_refresh_token,
        generate_access_token, generate_otp, generate_refresh_token,
        mark_otp_used, revoke_all_user_refresh_tokens, revoke_refresh_token,
        verify_password, verify_password_reset_otp,
    },
};

pub async fn login(
    State(state): State<Arc<AppState>>,
    Json(req): Json<LoginRequest>,
) -> AppResult<Json<LoginResponse>> {
    // Validate input
    if req.username.is_empty() && req.password.is_empty() {
        return Err(AppError::BadRequest(
            "Username dan password tidak boleh kosong. Silakan masukkan username dan password Anda.".to_string(),
        ));
    }
    
    if req.username.is_empty() {
        return Err(AppError::BadRequest(
            "Username tidak boleh kosong. Silakan masukkan username Anda.".to_string(),
        ));
    }
    
    if req.password.is_empty() {
        return Err(AppError::BadRequest(
            "Password tidak boleh kosong. Silakan masukkan password Anda.".to_string(),
        ));
    }

    // Get user from database
    let user = get_user_by_username(&state.pool, &req.username)
        .await
        .map_err(|e| AppError::Database(e))?
        .ok_or_else(|| AppError::Auth("User tidak terdaftar. Silakan daftar terlebih dahulu.".to_string()))?;

    if !user.is_active {
        return Err(AppError::Auth("Akun Anda tidak aktif. Silakan hubungi administrator.".to_string()));
    }

    // Verify password
    let is_valid = verify_password(&req.password, &user.password_hash)
        .map_err(|_| AppError::Auth("Terjadi kesalahan saat memverifikasi password. Silakan coba lagi nanti.".to_string()))?;
    
    if !is_valid {
        return Err(AppError::Auth("Password salah. Password yang Anda masukkan tidak sesuai. Silakan periksa kembali password Anda dan coba lagi.".to_string()));
    }

    // Get branch name if user has branch
    let branch_name = if let Some(ref branch_id) = user.branch_id {
        get_branch_by_id(&state.pool, branch_id)
            .await
            .map_err(|e| AppError::Database(e))?
            .map(|b| b.name)
    } else {
        None
    };

    // Generate tokens
    let access_token = generate_access_token(&user, branch_name, &state.config)?;
    
    let refresh_token_id = Uuid::new_v4().to_string();
    let refresh_token = generate_refresh_token(&user.id, &refresh_token_id, &state.config)?;
    
    create_refresh_token(
        &state.pool,
        &user.id,
        &refresh_token,
        state.config.refresh_token_expiry_days,
    )
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(LoginResponse {
        access_token,
        refresh_token,
    }))
}

pub async fn logout(
    State(state): State<Arc<AppState>>,
    Json(req): Json<RefreshTokenRequest>,
) -> AppResult<Json<LogoutResponse>> {
    // Revoke the refresh token
    revoke_refresh_token(&state.pool, &req.refresh_token)
        .await
        .map_err(|e| AppError::Database(e))?;

    Ok(Json(LogoutResponse {
        message: "Logout berhasil".to_string(),
    }))
}

pub async fn refresh_token(
    State(state): State<Arc<AppState>>,
    Json(req): Json<RefreshTokenRequest>,
) -> AppResult<Json<LoginResponse>> {
    // Decode and validate refresh token
    let claims = decode_refresh_token(&req.refresh_token, &state.config)?;

    // Check if token exists in database
    let _stored_token = sqlx::query_as::<_, crate::models::RefreshToken>(
        "SELECT * FROM refresh_tokens WHERE token = ?1 AND expires_at > CURRENT_TIMESTAMP",
    )
    .bind(&req.refresh_token)
    .fetch_optional(&state.pool)
    .await
    .map_err(|e| AppError::Database(e))?
    .ok_or_else(|| AppError::Auth("Refresh token tidak valid".to_string()))?;

    // Get user
    let user = sqlx::query_as::<_, crate::models::User>(
        "SELECT * FROM users WHERE id = ?1 AND is_active = 1",
    )
    .bind(&claims.sub)
    .fetch_optional(&state.pool)
    .await
    .map_err(|e| AppError::Database(e))?
    .ok_or_else(|| AppError::Auth("User tidak ditemukan".to_string()))?;

    // Get branch name
    let branch_name = if let Some(ref branch_id) = user.branch_id {
        get_branch_by_id(&state.pool, branch_id)
            .await
            .map_err(|e| AppError::Database(e))?
            .map(|b| b.name)
    } else {
        None
    };

    // Revoke old refresh token
    revoke_refresh_token(&state.pool, &req.refresh_token)
        .await
        .map_err(|e| AppError::Database(e))?;

    // Generate new tokens
    let access_token = generate_access_token(&user, branch_name, &state.config)?;
    
    let new_refresh_token_id = Uuid::new_v4().to_string();
    let new_refresh_token = generate_refresh_token(&user.id, &new_refresh_token_id, &state.config)?;
    
    create_refresh_token(
        &state.pool,
        &user.id,
        &new_refresh_token,
        state.config.refresh_token_expiry_days,
    )
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(LoginResponse {
        access_token,
        refresh_token: new_refresh_token,
    }))
}

pub async fn password_reset_request(
    State(state): State<Arc<AppState>>,
    Json(req): Json<PasswordResetRequest>,
) -> AppResult<Json<PasswordResetResponse>> {
    if req.username.is_empty() {
        return Err(AppError::BadRequest("Username harus diisi".to_string()));
    }

    // Find user
    let user = match get_user_by_username(&state.pool, &req.username).await {
        Ok(Some(u)) => u,
        _ => {
            // Return success even if user not found (security best practice)
            return Ok(Json(PasswordResetResponse {
                message: "Jika username valid, OTP akan dikirim".to_string(),
            }));
        }
    };

    // Generate OTP
    let otp = generate_otp();
    
    // Save OTP to database (15 minutes expiry)
    create_password_reset_otp(&state.pool, &user.id, &otp, 15)
        .await
        .map_err(|e| AppError::Database(e))?;

    // TODO: Send OTP via WhatsApp/SMS
    // For now, we just print it for development
    tracing::info!("OTP for user {}: {}", user.username, otp);

    Ok(Json(PasswordResetResponse {
        message: "OTP telah dikirim ke WhatsApp terdaftar".to_string(),
    }))
}

pub async fn password_reset_verify(
    State(state): State<Arc<AppState>>,
    Json(req): Json<PasswordResetVerifyRequest>,
) -> AppResult<Json<PasswordResetResponse>> {
    // Validate input
    if req.username.is_empty() || req.otp.is_empty() || req.new_password.is_empty() {
        return Err(AppError::BadRequest(
            "Username, OTP, dan password baru harus diisi".to_string(),
        ));
    }

    if req.new_password.len() < 6 {
        return Err(AppError::BadRequest(
            "Password minimal 6 karakter".to_string(),
        ));
    }

    // Find user
    let user = get_user_by_username(&state.pool, &req.username)
        .await
        .map_err(|e| AppError::Database(e))?
        .ok_or_else(|| AppError::Auth("User tidak ditemukan".to_string()))?;

    // Verify OTP
    let otp_valid = verify_password_reset_otp(&state.pool, &user.id, &req.otp)
        .await
        .map_err(|e| AppError::Database(e))?;

    if !otp_valid {
        return Err(AppError::Auth("OTP tidak valid atau sudah expired".to_string()));
    }

    // Hash new password
    let new_password_hash = hash(&req.new_password, bcrypt::DEFAULT_COST)
        .map_err(|_| AppError::Internal("Gagal memproses password".to_string()))?;

    // Update password
    update_user_password(&state.pool, &user.id, &new_password_hash)
        .await
        .map_err(|e| AppError::Database(e))?;

    // Mark OTP as used
    mark_otp_used(&state.pool, &user.id, &req.otp)
        .await
        .map_err(|e| AppError::Database(e))?;

    // Revoke all refresh tokens for this user (force re-login)
    revoke_all_user_refresh_tokens(&state.pool, &user.id)
        .await
        .map_err(|e| AppError::Database(e))?;

    Ok(Json(PasswordResetResponse {
        message: "Password berhasil direset. Silakan login dengan password baru.".to_string(),
    }))
}

