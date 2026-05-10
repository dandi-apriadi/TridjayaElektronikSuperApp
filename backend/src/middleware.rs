use axum::{
    extract::{Request, State},
    http::{header, StatusCode},
    middleware::Next,
    response::Response,
    RequestPartsExt,
};
use sqlx::{Pool, Postgres};
use std::sync::Arc;

use crate::{
    config::Config,
    error::AppError,
    utils::decode_access_token,
};

#[derive(Clone, Debug)]
pub struct CurrentUser {
    pub user_id: uuid::Uuid,
    pub email: String,
    pub full_name: String,
    pub role: UserRole,
    pub branch_id: Option<uuid::Uuid>,
}

#[derive(Clone, Debug, PartialEq)]
pub enum UserRole {
    Owner,
    KepalaCabang,
    Admin,
    Sales,
    Driver,
}

impl UserRole {
    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "owner" => Some(UserRole::Owner),
            "kepala_cabang" => Some(UserRole::KepalaCabang),
            "admin" => Some(UserRole::Admin),
            "sales" => Some(UserRole::Sales),
            "driver" => Some(UserRole::Driver),
            _ => None,
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            UserRole::Owner => "owner",
            UserRole::KepalaCabang => "kepala_cabang",
            UserRole::Admin => "admin",
            UserRole::Sales => "sales",
            UserRole::Driver => "driver",
        }
    }

    /// Check if role can access resource
    pub fn has_permission(&self, required: &[UserRole]) -> bool {
        required.contains(self) || *self == UserRole::Owner
    }
}

/// RBAC Helper: Create middleware that checks for specific roles
pub fn require_roles(roles: Vec<UserRole>) -> impl Fn(Request, Next) -> std::pin::Pin<Box<dyn std::future::Future<Output = Result<Response, AppError>> + Send>> {
    move |request: Request, next: Next| {
        let allowed_roles = roles.clone();
        Box::pin(async move {
            // Extract current user from request extensions
            let user = request.extensions().get::<CurrentUser>().cloned();
            
            match user {
                Some(user) => {
                    if user.role.has_permission(&allowed_roles) {
                        Ok(next.run(request).await)
                    } else {
                        Err(AppError::Forbidden)
                    }
                }
                None => Err(AppError::Unauthorized),
            }
        })
    }
}

pub async fn auth_middleware(
    State(pool): State<Pool<Postgres>>,
    State(config): State<Arc<Config>>,
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

    // Check if user still exists and is active (PostgreSQL query)
    let user: Option<(uuid::Uuid, String, String, Option<uuid::Uuid>)> = sqlx::query_as(
        "SELECT id, email, full_name, branch_id FROM users WHERE id = $1 AND status = 'active'"
    )
    .bind(&claims.sub)
    .fetch_optional(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let (user_id, email, full_name, branch_id) = match user {
        Some(u) => u,
        None => return Err(AppError::Unauthorized),
    };

    // Parse role
    let role = UserRole::from_str(&claims.role)
        .ok_or(AppError::Unauthorized)?;

    // Add user info to request extensions for handlers to access
    let mut request = request;
    request.extensions_mut().insert(CurrentUser {
        user_id,
        email,
        full_name,
        role,
        branch_id,
    });

    Ok(next.run(request).await)
}
