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
/// SCHEDULE HANDLER - Employee Schedule Management
/// ============================================================

// ===================== MODELS =====================

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Shift {
    pub id: String,
    pub user_id: String,
    pub title: String,
    pub shift_type: String, // morning, afternoon, night, custom
    pub start_time: DateTime<Utc>,
    pub end_time: DateTime<Utc>,
    pub location: Option<String>,
    pub notes: Option<String>,
    pub status: String, // scheduled, completed, cancelled
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScheduleEvent {
    pub id: String,
    pub title: String,
    pub shift_type: String,
    pub start_time: String,
    pub end_time: String,
    pub status: String,
    pub location: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TeamSchedule {
    pub date: String,
    pub employees: Vec<EmployeeShift>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmployeeShift {
    pub employee_name: String,
    pub shift_type: String,
    pub start_time: String,
    pub end_time: String,
    pub status: String,
}

// ===================== REQUESTS =====================

#[derive(Debug, Deserialize)]
pub struct CreateShiftRequest {
    pub title: String,
    pub shift_type: String,
    pub start_time: DateTime<Utc>,
    pub end_time: DateTime<Utc>,
    pub location: Option<String>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateShiftRequest {
    pub title: Option<String>,
    pub shift_type: Option<String>,
    pub start_time: Option<DateTime<Utc>>,
    pub end_time: Option<DateTime<Utc>>,
    pub location: Option<String>,
    pub notes: Option<String>,
    pub status: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AssignShiftRequest {
    pub user_id: String,
}

// ===================== HANDLERS =====================

/// GET /api/schedule/my-schedule - Get user's schedule
pub async fn get_my_schedule(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<Shift>>> {
    let pool = &state.pool;
    let shifts = sqlx::query_as::<_, Shift>(
        "SELECT id, user_id, title, shift_type, start_time, end_time, location, notes, status, created_at, updated_at
        FROM shifts
        WHERE user_id = ? AND start_time >= datetime('now', '-7 days')
        ORDER BY start_time ASC"
    )
    .bind(&current_user.user_id)
    .fetch_all(pool)
    .await?;

    Ok(Json(shifts))
}

/// GET /api/schedule/team-schedule - Get team's schedule (for managers)
pub async fn get_team_schedule(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<TeamSchedule>> {
    let pool = &state.pool;
    match current_user.role {
        UserRole::Owner | UserRole::Admin | UserRole::KepalaCabang => {},
        _ => return Err(AppError::Forbidden),
    }

    let shifts = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_as::<_, (String, String, DateTime<Utc>, DateTime<Utc>, String)>(
                "SELECT u.username, s.shift_type, s.start_time, s.end_time, s.status
                FROM shifts s
                JOIN users u ON s.user_id = u.id
                WHERE s.start_time >= datetime('now')
                ORDER BY s.start_time ASC"
            )
            .fetch_all(pool)
            .await?
        },
        UserRole::KepalaCabang => {
            sqlx::query_as::<_, (String, String, DateTime<Utc>, DateTime<Utc>, String)>(
                "SELECT u.username, s.shift_type, s.start_time, s.end_time, s.status
                FROM shifts s
                JOIN users u ON s.user_id = u.id
                WHERE (SELECT branch_id FROM users WHERE id = u.id) = (SELECT branch_id FROM users WHERE id = ?)
                AND s.start_time >= datetime('now')
                ORDER BY s.start_time ASC"
            )
            .bind(&current_user.user_id)
            .fetch_all(pool)
            .await?
        },
        _ => vec![],
    };

    let events = shifts
        .into_iter()
        .map(|(name, shift_type, start, end, status)| {
            EmployeeShift {
                employee_name: name,
                shift_type,
                start_time: start.format("%H:%M").to_string(),
                end_time: end.format("%H:%M").to_string(),
                status,
            }
        })
        .collect();

    Ok(Json(TeamSchedule {
        date: Utc::now().format("%Y-%m-%d").to_string(),
        employees: events,
    }))
}

/// GET /api/schedule/shifts/:id - Get shift detail
pub async fn get_shift(
    State(state): State<Arc<AppState>>,
    Path(shift_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Shift>> {
    let pool = &state.pool;
    let shift = sqlx::query_as::<_, Shift>(
        "SELECT id, user_id, title, shift_type, start_time, end_time, location, notes, status, created_at, updated_at
        FROM shifts
        WHERE id = ? AND (user_id = ? OR EXISTS(SELECT 1 FROM users WHERE id = ? AND role IN ('Owner', 'Admin', 'KepalaCabang')))"
    )
    .bind(&shift_id)
    .bind(&current_user.user_id)
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await?;

    Ok(Json(shift))
}

/// POST /api/schedule/shifts - Create new shift
pub async fn create_shift(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateShiftRequest>,
) -> AppResult<(StatusCode, Json<serde_json::Value>)> {
    let pool = &state.pool;
    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO shifts (id, user_id, title, shift_type, start_time, end_time, location, notes, status, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&req.title)
    .bind(&req.shift_type)
    .bind(&req.start_time)
    .bind(&req.end_time)
    .bind(&req.location)
    .bind(&req.notes)
    .bind("scheduled")
    .bind(&now)
    .bind(&now)
    .execute(pool)
    .await?;

    Ok((StatusCode::CREATED, Json(serde_json::json!({"id": id}))))
}

/// PUT /api/schedule/shifts/:id - Update shift
pub async fn update_shift(
    State(state): State<Arc<AppState>>,
    Path(shift_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<UpdateShiftRequest>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    let shift = sqlx::query_scalar::<_, String>("SELECT user_id FROM shifts WHERE id = ?")
        .bind(&shift_id)
        .fetch_one(pool)
        .await?;

    if shift != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    let now = Utc::now();

    sqlx::query(
        "UPDATE shifts SET
            title = COALESCE(?, title),
            shift_type = COALESCE(?, shift_type),
            start_time = COALESCE(?, start_time),
            end_time = COALESCE(?, end_time),
            location = COALESCE(?, location),
            notes = COALESCE(?, notes),
            status = COALESCE(?, status),
            updated_at = ?
        WHERE id = ?"
    )
    .bind(&req.title)
    .bind(&req.shift_type)
    .bind(&req.start_time)
    .bind(&req.end_time)
    .bind(&req.location)
    .bind(&req.notes)
    .bind(&req.status)
    .bind(&now)
    .bind(&shift_id)
    .execute(pool)
    .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// DELETE /api/schedule/shifts/:id - Delete shift
pub async fn delete_shift(
    State(state): State<Arc<AppState>>,
    Path(shift_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    let shift = sqlx::query_scalar::<_, String>("SELECT user_id FROM shifts WHERE id = ?")
        .bind(&shift_id)
        .fetch_one(pool)
        .await?;

    if shift != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    sqlx::query("DELETE FROM shifts WHERE id = ?")
        .bind(&shift_id)
        .execute(pool)
        .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// POST /api/schedule/shifts/:id/assign - Assign shift to user (admin)
pub async fn assign_shift(
    State(state): State<Arc<AppState>>,
    Path(shift_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<AssignShiftRequest>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    match current_user.role {
        UserRole::Owner | UserRole::Admin | UserRole::KepalaCabang => {},
        _ => return Err(AppError::Forbidden),
    }

    sqlx::query("UPDATE shifts SET user_id = ? WHERE id = ?")
        .bind(&req.user_id)
        .bind(&shift_id)
        .execute(pool)
        .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// GET /api/schedule/statistics - Get schedule statistics
pub async fn get_schedule_statistics(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    let (scheduled, completed, cancelled) = sqlx::query_as::<_, (i32, i32, i32)>(
        "SELECT
            SUM(CASE WHEN status = 'scheduled' THEN 1 ELSE 0 END) as scheduled,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed,
            SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled
        FROM shifts
        WHERE user_id = ?"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await?;

    Ok(Json(serde_json::json!({
        "scheduled": scheduled,
        "completed": completed,
        "cancelled": cancelled,
        "total": scheduled + completed + cancelled,
    })))
}
