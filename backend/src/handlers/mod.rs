pub mod auth;
pub mod owner;
pub mod kepala_cabang;
pub mod jobdesk;
pub mod work_report;
pub mod attendance;
pub mod inventory;
pub mod notification;

use axum::{extract::State, Json};
use serde_json::{json, Value};
use std::sync::Arc;
use crate::AppState;

/// Health check endpoint - returns server status and timestamp
pub async fn health_check(State(state): State<Arc<AppState>>) -> Json<Value> {
    let db_status = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM users")
        .fetch_one(&state.pool)
        .await
        .map(|_| "connected")
        .unwrap_or("error");

    Json(json!({
        "status": "ok",
        "database": db_status,
        "timestamp": chrono::Utc::now().to_rfc3339(),
        "version": "1.0.0"
    }))
}

/// Simple ping endpoint - returns pong quickly for connection testing
pub async fn ping() -> Json<Value> {
    Json(json!({
        "status": "ok",
        "message": "pong",
        "timestamp": chrono::Utc::now().to_rfc3339()
    }))
}

