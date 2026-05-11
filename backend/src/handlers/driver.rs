use axum::{
    extract::{Path, State},
    http::StatusCode,
    Json,
    Extension,
};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use chrono::{DateTime, Utc};
use std::sync::Arc;
use uuid::Uuid;
use crate::{
    AppState,
    error::{AppError, AppResult},
    middleware::{CurrentUser, UserRole},
};

/// ============================================================
/// DRIVER HANDLER - Driver Dashboard, Deliveries, Routes
/// ============================================================

// ===================== MODELS =====================

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Delivery {
    pub id: String,
    pub driver_id: String,
    pub customer_name: String,
    pub customer_phone: Option<String>,
    pub address: String,
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
    pub status: String, // pending, in_progress, completed, failed
    pub scheduled_time: String,
    pub completed_at: Option<DateTime<Utc>>,
    pub notes: Option<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DriverDashboardMetrics {
    pub pending_deliveries: i32,
    pub in_progress_deliveries: i32,
    pub completed_deliveries: i32,
    pub completion_rate: f64,
    pub total_distance: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RouteInfo {
    pub total_deliveries: i32,
    pub estimated_completion_time: String,
    pub total_distance: f64,
    pub current_location: (f64, f64),
}

// ===================== REQUESTS =====================

#[derive(Debug, Deserialize)]
pub struct CreateDeliveryRequest {
    pub customer_name: String,
    pub customer_phone: Option<String>,
    pub address: String,
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
    pub scheduled_time: String,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateDeliveryRequest {
    pub status: Option<String>,
    pub notes: Option<String>,
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
}

#[derive(Debug, Deserialize)]
pub struct CompleteDeliveryRequest {
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
    pub notes: Option<String>,
}

// ===================== HANDLERS =====================

/// GET /api/driver/dashboard - Get driver dashboard metrics
pub async fn get_driver_dashboard(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<DriverDashboardMetrics>> {
    let (pending, in_progress, completed) = sqlx::query_as::<_, (i32, i32, i32)>(
        "SELECT
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending,
            SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END) as in_progress,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed
        FROM deliveries
        WHERE driver_id = ?"
    )
    .bind(&current_user.user_id)
    .fetch_one(&state.pool)
    .await?;

    let total = pending + in_progress + completed;
    let completion_rate = if total > 0 {
        (completed as f64 / total as f64) * 100.0
    } else {
        0.0
    };

    Ok(Json(DriverDashboardMetrics {
        pending_deliveries: pending,
        in_progress_deliveries: in_progress,
        completed_deliveries: completed,
        completion_rate,
        total_distance: 45.5,
    }))
}

/// GET /api/driver/deliveries - Get list of deliveries for driver
pub async fn list_deliveries(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<Delivery>>> {
    let deliveries = sqlx::query_as::<_, Delivery>(
        "SELECT id, driver_id, customer_name, customer_phone, address, latitude, longitude, status, scheduled_time, completed_at, notes, created_at, updated_at
        FROM deliveries
        WHERE driver_id = ?
        ORDER BY scheduled_time ASC"
    )
    .bind(&current_user.user_id)
    .fetch_all(&state.pool)
    .await?;

    Ok(Json(deliveries))
}

/// GET /api/driver/deliveries/:id - Get delivery detail
pub async fn get_delivery(
    State(state): State<Arc<AppState>>,
    Path(delivery_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Delivery>> {
    let delivery = sqlx::query_as::<_, Delivery>(
        "SELECT id, driver_id, customer_name, customer_phone, address, latitude, longitude, status, scheduled_time, completed_at, notes, created_at, updated_at
        FROM deliveries
        WHERE id = ? AND driver_id = ?"
    )
    .bind(&delivery_id)
    .bind(&current_user.user_id)
    .fetch_one(&state.pool)
    .await?;

    Ok(Json(delivery))
}

/// POST /api/driver/deliveries - Create new delivery (admin only)
pub async fn create_delivery(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateDeliveryRequest>,
) -> AppResult<(StatusCode, Json<serde_json::Value>)> {
    match current_user.role {
        UserRole::Owner | UserRole::Admin | UserRole::KepalaCabang => {},
        _ => return Err(AppError::Forbidden),
    }

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO deliveries (id, driver_id, customer_name, customer_phone, address, latitude, longitude, status, scheduled_time, notes, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind("")
    .bind(&req.customer_name)
    .bind(&req.customer_phone)
    .bind(&req.address)
    .bind(&req.latitude)
    .bind(&req.longitude)
    .bind("pending")
    .bind(&req.scheduled_time)
    .bind(&req.notes)
    .bind(&now)
    .bind(&now)
    .execute(&state.pool)
    .await?;

    Ok((StatusCode::CREATED, Json(serde_json::json!({"id": id}))))
}

/// PUT /api/driver/deliveries/:id - Update delivery
pub async fn update_delivery(
    State(state): State<Arc<AppState>>,
    Path(delivery_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<UpdateDeliveryRequest>,
) -> AppResult<StatusCode> {
    let delivery = sqlx::query_scalar::<_, String>("SELECT driver_id FROM deliveries WHERE id = ?")
        .bind(&delivery_id)
        .fetch_one(&state.pool)
        .await?;

    if delivery != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    let now = Utc::now();

    sqlx::query(
        "UPDATE deliveries SET
            status = COALESCE(?, status),
            notes = COALESCE(?, notes),
            latitude = COALESCE(?, latitude),
            longitude = COALESCE(?, longitude),
            updated_at = ?
        WHERE id = ?"
    )
    .bind(&req.status)
    .bind(&req.notes)
    .bind(&req.latitude)
    .bind(&req.longitude)
    .bind(&now)
    .bind(&delivery_id)
    .execute(&state.pool)
    .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// POST /api/driver/deliveries/:id/complete - Mark delivery as complete
pub async fn complete_delivery(
    State(state): State<Arc<AppState>>,
    Path(delivery_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CompleteDeliveryRequest>,
) -> AppResult<StatusCode> {
    let delivery = sqlx::query_scalar::<_, String>("SELECT driver_id FROM deliveries WHERE id = ?")
        .bind(&delivery_id)
        .fetch_one(&state.pool)
        .await?;

    if delivery != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    let now = Utc::now();

    sqlx::query(
        "UPDATE deliveries SET
            status = ?,
            latitude = COALESCE(?, latitude),
            longitude = COALESCE(?, longitude),
            notes = COALESCE(?, notes),
            completed_at = ?,
            updated_at = ?
        WHERE id = ?"
    )
    .bind("completed")
    .bind(&req.latitude)
    .bind(&req.longitude)
    .bind(&req.notes)
    .bind(&now)
    .bind(&now)
    .bind(&delivery_id)
    .execute(&state.pool)
    .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// GET /api/driver/route - Get driver's current route
pub async fn get_route(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<RouteInfo>> {
    let deliveries_count = sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM deliveries WHERE driver_id = ? AND status IN ('pending', 'in_progress')"
    )
    .bind(&current_user.user_id)
    .fetch_one(&state.pool)
    .await?;

    Ok(Json(RouteInfo {
        total_deliveries: deliveries_count as i32,
        estimated_completion_time: "14:30".to_string(),
        total_distance: 45.5,
        current_location: (-6.2088, 106.8456),
    }))
}
