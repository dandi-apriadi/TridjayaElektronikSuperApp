use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct User {
    pub id: String,
    pub username: String,
    pub password_hash: String,
    pub role: String,
    pub branch_id: Option<String>,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Branch {
    pub id: String,
    pub name: String,
    pub address: Option<String>,
    pub phone: Option<String>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct RefreshToken {
    pub id: String,
    pub user_id: String,
    pub token: String,
    pub expires_at: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct PasswordResetOtp {
    pub id: String,
    pub user_id: String,
    pub otp: String,
    pub expires_at: DateTime<Utc>,
    pub used: bool,
    pub created_at: DateTime<Utc>,
}

// User Roles
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
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
    CS, // Customer Service
}

impl UserRole {
    pub fn as_str(&self) -> &'static str {
        match self {
            UserRole::Owner => "Owner",
            UserRole::KepalaCabang => "Kepala_Cabang",
            UserRole::PicPelaporan => "PIC_Pelaporan",
            UserRole::Admin => "Admin",
            UserRole::Sales => "Sales",
            UserRole::Driver => "Driver",
            UserRole::Teknisi => "Teknisi",
            UserRole::Gudang => "Gudang",
            UserRole::Kasir => "Kasir",
            UserRole::Marketing => "Marketing",
            UserRole::CS => "CS",
        }
    }

    pub fn from_str(s: &str) -> Option<Self> {
        match s {
            "Owner" => Some(UserRole::Owner),
            "Kepala_Cabang" => Some(UserRole::KepalaCabang),
            "PIC_Pelaporan" => Some(UserRole::PicPelaporan),
            "Admin" => Some(UserRole::Admin),
            "Sales" => Some(UserRole::Sales),
            "Driver" => Some(UserRole::Driver),
            "Teknisi" => Some(UserRole::Teknisi),
            "Gudang" => Some(UserRole::Gudang),
            "Kasir" => Some(UserRole::Kasir),
            "Marketing" => Some(UserRole::Marketing),
            "CS" => Some(UserRole::CS),
            _ => None,
        }
    }
}

// API Request/Response Models

#[derive(Debug, Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

#[derive(Debug, Serialize)]
pub struct LoginResponse {
    pub access_token: String,
    pub refresh_token: String,
}

#[derive(Debug, Deserialize)]
pub struct RefreshTokenRequest {
    pub refresh_token: String,
}

#[derive(Debug, Deserialize)]
pub struct PasswordResetRequest {
    pub username: String,
}

#[derive(Debug, Deserialize)]
pub struct PasswordResetVerifyRequest {
    pub username: String,
    pub otp: String,
    pub new_password: String,
}

#[derive(Debug, Serialize)]
pub struct PasswordResetResponse {
    pub message: String,
}

#[derive(Debug, Serialize)]
pub struct LogoutResponse {
    pub message: String,
}

// JWT Claims
#[derive(Debug, Serialize, Deserialize)]
pub struct JwtClaims {
    pub sub: String,        // user id
    pub username: String,
    pub role: String,
    pub branch_id: Option<String>,
    pub branch_name: Option<String>,
    pub exp: usize,       // expiration time
    pub iat: usize,       // issued at
}

#[derive(Debug, Serialize, Deserialize)]
pub struct JwtRefreshClaims {
    pub sub: String,        // user id
    pub token_id: String, // refresh token id
    pub exp: usize,
    pub iat: usize,
}
