use axum::{
    extract::{Query, State},
    Json,
    Extension,
};
use chrono::{NaiveDate, Utc};
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

#[derive(Debug, Deserialize)]
pub struct CreateWorkReportRequest {
    pub report_date: NaiveDate,
    pub content: String,
    pub achievements: Option<String>,
    pub challenges: Option<String>,
    pub photo_urls: Option<Vec<String>>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateWorkReportRequest {
    pub content: Option<String>,
    pub achievements: Option<String>,
    pub challenges: Option<String>,
    pub photo_urls: Option<Vec<String>>,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct WorkReport {
    pub id: String,
    pub user_id: String,
    pub branch_id: String,
    pub report_date: NaiveDate,
    pub content: String,
    pub achievements: Option<String>,
    pub challenges: Option<String>,
    pub photos: sqlx::types::Json<Vec<String>>,
    pub status: String,
    pub submitted_at: String,
    pub reviewed_by: Option<String>,
    pub reviewed_at: Option<String>,
    pub rejection_reason: Option<String>,
    pub employee_name: Option<String>,
    pub reviewer_name: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct WorkReportStats {
    pub total_reports: i64,
    pub pending_count: i64,
    pub approved_count: i64,
    pub rejected_count: i64,
    pub this_month_count: i64,
}

// ============================================
// CREATE WORK REPORT (Staff)
// POST /api/work-reports
// ============================================
pub async fn create_work_report(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateWorkReportRequest>,
) -> AppResult<Json<WorkReport>> {
    let pool = &state.pool;
    
    // Validasi input
    if req.content.trim().is_empty() {
        return Err(AppError::BadRequest("Isi laporan tidak boleh kosong".to_string()));
    }
    
    // Cek apakah sudah submit untuk tanggal ini
    let existing: Option<(String,)> = sqlx::query_as(
        "SELECT id FROM work_reports WHERE user_id = ?1 AND report_date = ?2"
    )
    .bind(&current_user.user_id)
    .bind(req.report_date)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    if existing.is_some() {
        return Err(AppError::BadRequest(
            "Anda sudah mengirim laporan untuk tanggal ini. Silakan edit laporan yang ada.".to_string()
        ));
    }
    
    let branch_id = current_user.branch_id
        .ok_or(AppError::BadRequest("User tidak memiliki cabang".to_string()))?;
    
    let id = Uuid::new_v4().to_string();
    let photos = req.photo_urls.unwrap_or_default();
    let submitted_at = Utc::now().to_rfc3339();
    
    sqlx::query(
        r#"
        INSERT INTO work_reports (
            id, user_id, branch_id, report_date, content, 
            achievements, challenges, photos, status, submitted_at
        ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10)
        "#
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&branch_id)
    .bind(req.report_date)
    .bind(&req.content)
    .bind(&req.achievements)
    .bind(&req.challenges)
    .bind(sqlx::types::Json(photos))
    .bind("submitted")
    .bind(&submitted_at)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // Return created report
    let report = get_work_report_by_id(pool, &id).await?;
    
    Ok(Json(report))
}

// ============================================
// GET MY WORK REPORTS (Staff)
// GET /api/work-reports/my
// ============================================
pub async fn get_my_work_reports(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<Vec<WorkReport>>> {
    let pool = &state.pool;
    
    let mut query = String::from(
        r#"
        SELECT 
            wr.*,
            u.username as employee_name,
            reviewer.username as reviewer_name
        FROM work_reports wr
        JOIN users u ON u.id = wr.user_id
        LEFT JOIN users reviewer ON reviewer.id = wr.reviewed_by
        WHERE wr.user_id = ?1
        "#
    );
    
    // Filter by status
    if let Some(status) = params.get("status") {
        query.push_str(" AND wr.status = ?");
    }
    
    // Filter by date range
    if let Some(start_date) = params.get("start_date") {
        query.push_str(" AND wr.report_date >= ?");
    }
    if let Some(end_date) = params.get("end_date") {
        query.push_str(" AND wr.report_date <= ?");
    }
    
    query.push_str(" ORDER BY wr.report_date DESC");
    
    let mut q = sqlx::query_as::<_, WorkReport>(&query);
    
    q = q.bind(&current_user.user_id);
    
    if let Some(status) = params.get("status") {
        q = q.bind(status);
    }
    
    if let Some(start_date) = params.get("start_date") {
        q = q.bind(start_date);
    }
    if let Some(end_date) = params.get("end_date") {
        q = q.bind(end_date);
    }
    
    let reports: Vec<WorkReport> = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(reports))
}

// ============================================
// GET WORK REPORT DETAIL
// GET /api/work-reports/:id
// ============================================
pub async fn get_work_report_detail(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> AppResult<Json<WorkReport>> {
    let pool = &state.pool;
    
    let report = get_work_report_by_id(pool, &id).await?;
    
    // Cek permission - hanya pemilik, kepala cabang, atau owner yang bisa lihat
    if report.user_id != current_user.user_id 
        && current_user.role != UserRole::KepalaCabang
        && current_user.role != UserRole::PicPelaporan
        && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    // Kepala cabang hanya bisa lihat laporan dari cabangnya
    if current_user.role == UserRole::KepalaCabang {
        let user_branch = current_user.branch_id.ok_or(AppError::Forbidden)?;
        if report.branch_id != user_branch {
            return Err(AppError::Forbidden);
        }
    }
    
    Ok(Json(report))
}

// ============================================
// UPDATE WORK REPORT (Staff - hanya yang belum di-review)
// PUT /api/work-reports/:id
// ============================================
pub async fn update_work_report(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
    Json(req): Json<UpdateWorkReportRequest>,
) -> AppResult<Json<WorkReport>> {
    let pool = &state.pool;
    
    // Cek apakah report exists dan milik user ini
    let report: (String, String) = sqlx::query_as(
        "SELECT id, status FROM work_reports WHERE id = ?1 AND user_id = ?2"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Laporan tidak ditemukan".to_string()))?;
    
    // Hanya bisa edit kalau status masih submitted (belum di-review)
    if report.1 != "submitted" {
        return Err(AppError::BadRequest(
            "Laporan sudah di-review dan tidak bisa diubah".to_string()
        ));
    }
    
    // Build dynamic query with safe placeholders
    let mut set_clauses = vec![];
    let mut binds: Vec<String> = vec![];
    
    if let Some(content) = req.content {
        set_clauses.push("content = ?");
        binds.push(content);
    }
    if let Some(achievements) = req.achievements {
        set_clauses.push("achievements = ?");
        binds.push(achievements);
    }
    if let Some(challenges) = req.challenges {
        set_clauses.push("challenges = ?");
        binds.push(challenges);
    }
    if let Some(photos) = req.photo_urls {
        let photos_json = serde_json::to_string(&photos).unwrap_or_default();
        set_clauses.push("photos = ?");
        binds.push(photos_json);
    }
    
    if set_clauses.is_empty() {
        return Err(AppError::BadRequest("Tidak ada data yang diupdate".to_string()));
    }
    
    let query = format!(
        "UPDATE work_reports SET {} WHERE id = ?",
        set_clauses.join(", ")
    );
    
    let mut q = sqlx::query(&query);
    for bind in binds {
        q = q.bind(bind);
    }
    q = q.bind(&id);
    
    q.execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    let updated_report = get_work_report_by_id(pool, &id).await?;
    Ok(Json(updated_report))
}

// ============================================
// DELETE WORK REPORT (Staff - hanya yang belum di-review)
// DELETE /api/work-reports/:id
// ============================================
pub async fn delete_work_report(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    
    // Cek apakah report exists, milik user ini, dan belum di-review
    let report: (String, String) = sqlx::query_as(
        "SELECT id, status FROM work_reports WHERE id = ?1 AND user_id = ?2"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Laporan tidak ditemukan".to_string()))?;
    
    if report.1 != "submitted" {
        return Err(AppError::BadRequest(
            "Laporan sudah di-review dan tidak bisa dihapus".to_string()
        ));
    }
    
    sqlx::query("DELETE FROM work_reports WHERE id = ?1")
        .bind(&id)
        .execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(serde_json::json!({
        "message": "Laporan berhasil dihapus"
    })))
}

// ============================================
// GET WORK REPORT STATS (Staff)
// GET /api/work-reports/stats
// ============================================
pub async fn get_work_report_stats(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<WorkReportStats>> {
    let pool = &state.pool;
    
    let total: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM work_reports WHERE user_id = ?1"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let pending: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM work_reports WHERE user_id = ?1 AND status = 'submitted'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let approved: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM work_reports WHERE user_id = ?1 AND status = 'approved'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let rejected: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM work_reports WHERE user_id = ?1 AND status = 'rejected'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let this_month: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*) FROM work_reports 
        WHERE user_id = ?1 
        AND strftime('%Y-%m', report_date) = strftime('%Y-%m', 'now')
        "#
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(WorkReportStats {
        total_reports: total,
        pending_count: pending,
        approved_count: approved,
        rejected_count: rejected,
        this_month_count: this_month,
    }))
}

// ============================================
// HELPER FUNCTIONS
// ============================================

async fn get_work_report_by_id(pool: &Pool<Sqlite>, id: &str) -> AppResult<WorkReport> {
    let report: WorkReport = sqlx::query_as(
        r#"
        SELECT 
            wr.*,
            u.username as employee_name,
            reviewer.username as reviewer_name
        FROM work_reports wr
        JOIN users u ON u.id = wr.user_id
        LEFT JOIN users reviewer ON reviewer.id = wr.reviewed_by
        WHERE wr.id = ?1
        "#
    )
    .bind(id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Laporan tidak ditemukan".to_string()))?;
    
    Ok(report)
}
