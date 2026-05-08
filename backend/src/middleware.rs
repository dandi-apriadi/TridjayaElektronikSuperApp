use axum::{
    extract::{Request, State},
    http::{header, StatusCode},
    middleware::Next,
    response::Response,
    RequestPartsExt,
};
// axum_extra imports removed — headers are read manually from request
use sqlx::{Pool, Sqlite};

use crate::{
    config::Config,
    error::AppError,
    utils::decode_access_token,
};

#[derive(Clone)]
pub struct CurrentUser {
    pub user_id: String,
    pub username: String,
    pub role: String,
    pub branch_id: Option<String>,
}

pub async fn auth_middleware(
    State(pool): State<Pool<Sqlite>>,
    State(config): State<Config>,
    request: Request,
    next: Next,
) -> Result<Response, AppError> {
    // Extract authorization header
    let auth_header = request
        .headers()
        .get(header::AUTHORIZATION)
        .and_then(|h| h.to_str().ok())
        .and_then(|h| h.strip_prefix("Bearer "));

    let token = match auth_header {
        Some(token) => token,
        None => {
            return Err(AppError::Unauthorized);
        }
    };

    // Decode and validate token
    let claims = decode_access_token(token, &config)?;

    // Check if user still exists and is active
    let user_exists: bool = sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM users WHERE id = ?1 AND is_active = 1)",
    )
    .bind(&claims.sub)
    .fetch_one(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    if !user_exists {
        return Err(AppError::Unauthorized);
    }

    // Add user info to request extensions for handlers to access
    let mut request = request;
    request.extensions_mut().insert(CurrentUser {
        user_id: claims.sub,
        username: claims.username,
        role: claims.role,
        branch_id: claims.branch_id,
    });

    Ok(next.run(request).await)
}
