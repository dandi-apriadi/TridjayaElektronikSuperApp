use axum::{
    extract::{Query, State},
    Json,
    Extension,
};
use chrono::Utc;
use serde::{Deserialize, Serialize};
use sqlx::{Pool, Sqlite};
use std::sync::Arc;
use uuid::Uuid;

use crate::{
    AppState,
    error::{AppError, AppResult},
    middleware::{CurrentUser, UserRole},
};

// ============================================
// REQUEST/RESPONSE MODELS
// ============================================

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct Notification {
    pub id: String,
    pub user_id: String,
    pub r#type: String, // jobdesk, attendance, approval, system, announcement
    pub title: String,
    pub message: String,
    pub is_read: bool,
    pub action_route: Option<String>,
    pub action_params: Option<String>, // JSON string
    pub created_at: String,
}

#[derive(Debug, Serialize)]
pub struct NotificationResponse {
    pub id: String,
    pub r#type: String,
    pub title: String,
    pub message: String,
    pub is_read: bool,
    pub action_route: Option<String>,
    pub action_params: Option<serde_json::Value>,
    pub created_at: String,
}

#[derive(Debug, Serialize)]
pub struct UnreadCountResponse {
    pub unread_count: i64,
}

#[derive(Debug, Serialize)]
pub struct NotificationListResponse {
    pub notifications: Vec<NotificationResponse>,
    pub total: i64,
    pub unread_count: i64,
}

#[derive(Debug, Deserialize)]
pub struct MarkReadRequest {
    pub is_read: bool,
}

// ============================================
// CREATE NOTIFICATION (Internal use - for system events)
// POST /api/notifications/create (Admin/Owner only)
// ============================================
pub async fn create_notification(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<serde_json::Value>,
) -> AppResult<Json<Notification>> {
    let pool = &state.pool;
    
    // Only Owner and Admin can create notifications
    if current_user.role != UserRole::Owner && current_user.role != UserRole::Admin {
        return Err(AppError::Forbidden);
    }
    
    let user_id = payload["user_id"]
        .as_str()
        .ok_or(AppError::BadRequest("user_id diperlukan".to_string()))?;
    
    let notification_type = payload["type"]
        .as_str()
        .ok_or(AppError::BadRequest("type diperlukan".to_string()))?;
    
    let title = payload["title"]
        .as_str()
        .ok_or(AppError::BadRequest("title diperlukan".to_string()))?;
    
    let message = payload["message"]
        .as_str()
        .ok_or(AppError::BadRequest("message diperlukan".to_string()))?;
    
    let action_route = payload["action_route"].as_str();
    let action_params = payload["action_params"].as_object().map(|v| serde_json::to_string(v).unwrap_or_default());
    
    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();
    
    sqlx::query(
        r#"
        INSERT INTO notifications (
            id, user_id, type, title, message, is_read, action_route, action_params, created_at
        ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)
        "#
    )
    .bind(&id)
    .bind(user_id)
    .bind(notification_type)
    .bind(title)
    .bind(message)
    .bind(0)
    .bind(action_route)
    .bind(&action_params)
    .bind(&now)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(Notification {
        id,
        user_id: user_id.to_string(),
        r#type: notification_type.to_string(),
        title: title.to_string(),
        message: message.to_string(),
        is_read: false,
        action_route: action_route.map(|s| s.to_string()),
        action_params,
        created_at: now,
    }))
}

// ============================================
// GET ALL NOTIFICATIONS
// GET /api/notifications
// ============================================
pub async fn get_notifications(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<NotificationListResponse>> {
    let pool = &state.pool;
    
    let limit = params
        .get("limit")
        .and_then(|l| l.parse::<i64>().ok())
        .unwrap_or(50);
    
    let offset = params
        .get("offset")
        .and_then(|o| o.parse::<i64>().ok())
        .unwrap_or(0);
    
    let unread_only = params
        .get("unread_only")
        .map(|v| v == "true")
        .unwrap_or(false);
    
    let filter_type = params.get("type");
    
    // Build query with safe placeholders
    let mut where_clause = String::from("WHERE user_id = ?");
    let mut bind_count = 1;
    
    if unread_only {
        where_clause.push_str(" AND is_read = 0");
    }
    
    if filter_type.is_some() {
        bind_count += 1;
        where_clause.push_str(" AND type = ?");
    }
    
    // Get total count
    let total_query = format!("SELECT COUNT(*) FROM notifications {}", where_clause);
    let mut total_q = sqlx::query_scalar::<_, i64>(&total_query)
        .bind(&current_user.user_id);
    if let Some(ntype) = filter_type {
        total_q = total_q.bind(ntype);
    }
    let total: i64 = total_q
        .fetch_one(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    // Get notifications
    let list_query = format!(
        "SELECT * FROM notifications {} ORDER BY created_at DESC LIMIT ? OFFSET ?",
        where_clause
    );
    let mut list_q = sqlx::query_as::<_, Notification>(&list_query)
        .bind(&current_user.user_id);
    if let Some(ntype) = filter_type {
        list_q = list_q.bind(ntype);
    }
    let notifications: Vec<Notification> = list_q
        .bind(limit)
        .bind(offset)
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    // Get unread count
    let unread_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let notification_responses = notifications
        .into_iter()
        .map(|n| NotificationResponse {
            id: n.id,
            r#type: n.r#type,
            title: n.title,
            message: n.message,
            is_read: n.is_read,
            action_route: n.action_route,
            action_params: n.action_params.and_then(|ap| serde_json::from_str(&ap).ok()),
            created_at: n.created_at,
        })
        .collect();
    
    Ok(Json(NotificationListResponse {
        notifications: notification_responses,
        total,
        unread_count,
    }))
}

// ============================================
// GET UNREAD COUNT
// GET /api/notifications/unread-count
// ============================================
pub async fn get_unread_count(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<UnreadCountResponse>> {
    let pool = &state.pool;
    
    let unread_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM notifications WHERE user_id = ?1 AND is_read = 0"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(UnreadCountResponse { unread_count }))
}

// ============================================
// MARK NOTIFICATION AS READ
// PUT /api/notifications/:id/read
// ============================================
pub async fn mark_as_read(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> AppResult<Json<NotificationResponse>> {
    let pool = &state.pool;
    
    // Verify ownership
    let notification: (String,) = sqlx::query_as(
        "SELECT user_id FROM notifications WHERE id = ?1"
    )
    .bind(&id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Notifikasi tidak ditemukan".to_string()))?;
    
    if notification.0 != current_user.user_id {
        return Err(AppError::Forbidden);
    }
    
    sqlx::query(
        "UPDATE notifications SET is_read = 1 WHERE id = ?1"
    )
    .bind(&id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let updated_notification: Notification = sqlx::query_as(
        "SELECT * FROM notifications WHERE id = ?1"
    )
    .bind(&id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Notifikasi tidak ditemukan".to_string()))?;
    
    Ok(Json(NotificationResponse {
        id: updated_notification.id,
        r#type: updated_notification.r#type,
        title: updated_notification.title,
        message: updated_notification.message,
        is_read: updated_notification.is_read,
        action_route: updated_notification.action_route,
        action_params: updated_notification.action_params.and_then(|ap| serde_json::from_str(&ap).ok()),
        created_at: updated_notification.created_at,
    }))
}

// ============================================
// MARK ALL NOTIFICATIONS AS READ
// PUT /api/notifications/read-all
// ============================================
pub async fn mark_all_as_read(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    sqlx::query(
        "UPDATE notifications SET is_read = 1 WHERE user_id = ?1 AND is_read = 0"
    )
    .bind(&current_user.user_id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(serde_json::json!({
        "success": true,
        "message": "Semua notifikasi telah ditandai sebagai dibaca"
    })))
}

// ============================================
// DELETE NOTIFICATION
// DELETE /api/notifications/:id
// ============================================
pub async fn delete_notification(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    // Verify ownership
    let notification: (String,) = sqlx::query_as(
        "SELECT user_id FROM notifications WHERE id = ?1"
    )
    .bind(&id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Notifikasi tidak ditemukan".to_string()))?;
    
    if notification.0 != current_user.user_id {
        return Err(AppError::Forbidden);
    }
    
    sqlx::query(
        "DELETE FROM notifications WHERE id = ?1"
    )
    .bind(&id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(serde_json::json!({
        "success": true,
        "message": "Notifikasi berhasil dihapus"
    })))
}

// ============================================
// DELETE ALL NOTIFICATIONS
// DELETE /api/notifications
// ============================================
pub async fn delete_all_notifications(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    sqlx::query(
        "DELETE FROM notifications WHERE user_id = ?1"
    )
    .bind(&current_user.user_id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(serde_json::json!({
        "success": true,
        "message": "Semua notifikasi telah dihapus"
    })))
}

// ============================================
// GET NOTIFICATION PREFERENCES
// GET /api/notifications/preferences
// ============================================
pub async fn get_notification_preferences(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    let prefs: Option<(bool, bool, bool, bool, bool)> = sqlx::query_as(
        "SELECT enable_jobdesk, enable_attendance, enable_approval, enable_system, enable_announcement FROM notification_preferences WHERE user_id = ?1"
    )
    .bind(&current_user.user_id)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let response = if let Some((jobdesk, attendance, approval, system, announcement)) = prefs {
        serde_json::json!({
            "enable_jobdesk": jobdesk,
            "enable_attendance": attendance,
            "enable_approval": approval,
            "enable_system": system,
            "enable_announcement": announcement,
        })
    } else {
        serde_json::json!({
            "enable_jobdesk": true,
            "enable_attendance": true,
            "enable_approval": true,
            "enable_system": true,
            "enable_announcement": true,
        })
    };
    
    Ok(Json(response))
}

// ============================================
// UPDATE NOTIFICATION PREFERENCES
// PUT /api/notifications/preferences
// ============================================
pub async fn update_notification_preferences(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(payload): Json<serde_json::Value>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    let enable_jobdesk = payload["enable_jobdesk"].as_bool().unwrap_or(true);
    let enable_attendance = payload["enable_attendance"].as_bool().unwrap_or(true);
    let enable_approval = payload["enable_approval"].as_bool().unwrap_or(true);
    let enable_system = payload["enable_system"].as_bool().unwrap_or(true);
    let enable_announcement = payload["enable_announcement"].as_bool().unwrap_or(true);
    
    // Check if preferences exist
    let exists: bool = sqlx::query_scalar(
        "SELECT COUNT(*) > 0 FROM notification_preferences WHERE user_id = ?1"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    if exists {
        sqlx::query(
            "UPDATE notification_preferences SET enable_jobdesk = ?1, enable_attendance = ?2, enable_approval = ?3, enable_system = ?4, enable_announcement = ?5, updated_at = ?6 WHERE user_id = ?7"
        )
        .bind(enable_jobdesk as i32)
        .bind(enable_attendance as i32)
        .bind(enable_approval as i32)
        .bind(enable_system as i32)
        .bind(enable_announcement as i32)
        .bind(Utc::now().to_rfc3339())
        .bind(&current_user.user_id)
        .execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    } else {
        let id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO notification_preferences (id, user_id, enable_jobdesk, enable_attendance, enable_approval, enable_system, enable_announcement) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)"
        )
        .bind(&id)
        .bind(&current_user.user_id)
        .bind(enable_jobdesk as i32)
        .bind(enable_attendance as i32)
        .bind(enable_approval as i32)
        .bind(enable_system as i32)
        .bind(enable_announcement as i32)
        .execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    }
    
    Ok(Json(serde_json::json!({
        "success": true,
        "message": "Preferensi notifikasi berhasil diperbarui"
    })))
}
