use axum::{
    extract::{Query, State},
    http::StatusCode,
    response::Json,
    Extension,
};
use chrono::{NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{Pool, Postgres};
use std::sync::Arc;

use crate::{
    config::Config,
    error::AppError,
    middleware::{CurrentUser, UserRole},
};

/// ===========================================
/// REQUEST/RESPONSE MODELS
/// ===========================================

#[derive(Debug, Deserialize)]
pub struct DateRangeQuery {
    pub start_date: Option<NaiveDate>,
    pub end_date: Option<NaiveDate>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct BranchDashboard {
    pub branch_id: String,
    pub branch_name: String,
    pub branch_code: String,
    pub total_employees: i64,
    pub active_employees: i64,
    pub pending_jobdesk: i64,
    pub pending_work_reports: i64,
    pub today_attendance: i64,
    pub on_leave: i64,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct EmployeeSummary {
    pub id: String,
    pub full_name: String,
    pub email: String,
    pub role: String,
    pub department: String,
    pub phone: String,
    pub status: String,
    pub last_login_at: Option<String>,
    pub jobdesk_status: Option<String>,
    pub work_report_status: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct JobDeskReviewItem {
    pub id: String,
    pub employee_id: String,
    pub employee_name: String,
    pub title: String,
    pub assigned_date: NaiveDate,
    pub submitted_at: String,
    pub photos: serde_json::Value,
    pub notes: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct WorkReportReviewItem {
    pub id: String,
    pub employee_id: String,
    pub employee_name: String,
    pub report_date: NaiveDate,
    pub content: String,
    pub achievements: Option<String>,
    pub challenges: Option<String>,
    pub photos: serde_json::Value,
    pub submitted_at: String,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct AttendanceSummary {
    pub date: NaiveDate,
    pub present: i64,
    pub absent: i64,
    pub on_leave: i64,
    pub late: i64,
}

/// ===========================================
/// HANDLER: GET BRANCH DASHBOARD
/// GET /api/kepala-cabang/dashboard
/// ===========================================
pub async fn get_branch_dashboard(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<BranchDashboard>, AppError> {
    // Verify user is kepala cabang
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    let branch_id = current_user.branch_id
        .ok_or(AppError::Forbidden)?;

    let today = Utc::now().naive_utc().date();

    // Get dashboard data
    let dashboard: BranchDashboard = sqlx::query_as(
        r#"
        SELECT 
            b.id::text as branch_id,
            b.name as branch_name,
            b.code as branch_code,
            COUNT(DISTINCT u.id) as total_employees,
            COUNT(DISTINCT CASE WHEN u.status = 'active' THEN u.id END) as active_employees,
            COUNT(DISTINCT CASE WHEN jd.status = 'completed' AND jd.approved_by IS NULL THEN jd.id END) as pending_jobdesk,
            COUNT(DISTINCT CASE WHEN wr.status = 'submitted' THEN wr.id END) as pending_work_reports,
            COUNT(DISTINCT CASE WHEN a.status = 'present' AND a.date = $1 THEN a.id END) as today_attendance,
            COUNT(DISTINCT CASE WHEN lr.status = 'approved' AND $1 BETWEEN lr.start_date AND lr.end_date THEN lr.id END) as on_leave
        FROM branches b
        LEFT JOIN users u ON u.branch_id = b.id
        LEFT JOIN jobdesk_assignments jd ON jd.user_id = u.id AND jd.assigned_date = $1
        LEFT JOIN work_reports wr ON wr.user_id = u.id AND wr.report_date = $1
        LEFT JOIN attendance a ON a.user_id = u.id AND a.date = $1
        LEFT JOIN leave_requests lr ON lr.user_id = u.id AND lr.status = 'approved'
        WHERE b.id = $2
        GROUP BY b.id, b.name, b.code
        "#
    )
    .bind(today)
    .bind(branch_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(dashboard))
}

/// ===========================================
/// HANDLER: GET BRANCH EMPLOYEES
/// GET /api/kepala-cabang/employees
/// ===========================================
pub async fn get_branch_employees(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<EmployeeSummary>>, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    let branch_id = current_user.branch_id
        .ok_or(AppError::Forbidden)?;

    let today = Utc::now().naive_utc().date();

    let employees: Vec<EmployeeSummary> = sqlx::query_as(
        r#"
        SELECT 
            u.id::text,
            u.full_name,
            u.email,
            u.role::text,
            u.department,
            u.phone,
            u.status::text,
            u.last_login_at::text,
            jd.status::text as jobdesk_status,
            wr.status::text as work_report_status
        FROM users u
        LEFT JOIN jobdesk_assignments jd ON jd.user_id = u.id AND jd.assigned_date = $1
        LEFT JOIN work_reports wr ON wr.user_id = u.id AND wr.report_date = $1
        WHERE u.branch_id = $2
        ORDER BY u.full_name
        "#
    )
    .bind(today)
    .bind(branch_id)
    .fetch_all(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(employees))
}

/// ===========================================
/// HANDLER: GET PENDING JOB DESK REVIEWS
/// GET /api/kepala-cabang/jobdesk/pending
/// ===========================================
pub async fn get_pending_jobdesk(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<JobDeskReviewItem>>, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    let branch_id = current_user.branch_id
        .ok_or(AppError::Forbidden)?;

    let pending: Vec<JobDeskReviewItem> = sqlx::query_as(
        r#"
        SELECT 
            jd.id::text,
            u.id::text as employee_id,
            u.full_name as employee_name,
            jd.title,
            jd.assigned_date,
            jd.submitted_at::text,
            jd.photos,
            jd.notes
        FROM jobdesk_assignments jd
        JOIN users u ON u.id = jd.user_id
        WHERE u.branch_id = $1
        AND jd.status = 'completed'
        AND jd.approved_by IS NULL
        ORDER BY jd.submitted_at DESC
        "#
    )
    .bind(branch_id)
    .fetch_all(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(pending))
}

/// ===========================================
/// HANDLER: GET PENDING WORK REPORTS
/// GET /api/kepala-cabang/work-reports/pending
/// ===========================================
pub async fn get_pending_work_reports(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<WorkReportReviewItem>>, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    let branch_id = current_user.branch_id
        .ok_or(AppError::Forbidden)?;

    let pending: Vec<WorkReportReviewItem> = sqlx::query_as(
        r#"
        SELECT 
            wr.id::text,
            u.id::text as employee_id,
            u.full_name as employee_name,
            wr.report_date,
            wr.content,
            wr.achievements,
            wr.challenges,
            wr.photos,
            wr.submitted_at::text
        FROM work_reports wr
        JOIN users u ON u.id = wr.user_id
        WHERE wr.branch_id = $1
        AND wr.status = 'submitted'
        ORDER BY wr.submitted_at DESC
        "#
    )
    .bind(branch_id)
    .fetch_all(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(pending))
}

/// ===========================================
/// HANDLER: APPROVE JOB DESK
/// POST /api/kepala-cabang/jobdesk/:id/approve
/// ===========================================
#[derive(Debug, Deserialize)]
pub struct ApproveRequest {
    pub notes: Option<String>,
}

pub async fn approve_jobdesk(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(jobdesk_id): axum::extract::Path<uuid::Uuid>,
) -> Result<StatusCode, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    sqlx::query(
        r#"
        UPDATE jobdesk_assignments
        SET approved_by = $1,
            approved_at = NOW()
        WHERE id = $2
        AND status = 'completed'
        AND approved_by IS NULL
        "#
    )
    .bind(current_user.user_id)
    .bind(jobdesk_id)
    .execute(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(StatusCode::OK)
}

/// ===========================================
/// HANDLER: REJECT JOB DESK
/// POST /api/kepala-cabang/jobdesk/:id/reject
/// ===========================================
#[derive(Debug, Deserialize)]
pub struct RejectRequest {
    pub reason: String,
}

pub async fn reject_jobdesk(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(jobdesk_id): axum::extract::Path<uuid::Uuid>,
    Json(body): Json<RejectRequest>,
) -> Result<StatusCode, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    sqlx::query(
        r#"
        UPDATE jobdesk_assignments
        SET approved_by = $1,
            approved_at = NOW(),
            rejection_reason = $2
        WHERE id = $3
        AND status = 'completed'
        AND approved_by IS NULL
        "#
    )
    .bind(current_user.user_id)
    .bind(body.reason)
    .bind(jobdesk_id)
    .execute(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(StatusCode::OK)
}

/// ===========================================
/// HANDLER: APPROVE WORK REPORT
/// POST /api/kepala-cabang/work-reports/:id/approve
/// ===========================================
pub async fn approve_work_report(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(report_id): axum::extract::Path<uuid::Uuid>,
) -> Result<StatusCode, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    sqlx::query(
        r#"
        UPDATE work_reports
        SET status = 'approved',
            reviewed_by = $1,
            reviewed_at = NOW()
        WHERE id = $2
        AND status = 'submitted'
        "#
    )
    .bind(current_user.user_id)
    .bind(report_id)
    .execute(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(StatusCode::OK)
}

/// ===========================================
/// HANDLER: REJECT WORK REPORT
/// POST /api/kepala-cabang/work-reports/:id/reject
/// ===========================================
pub async fn reject_work_report(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(report_id): axum::extract::Path<uuid::Uuid>,
    Json(body): Json<RejectRequest>,
) -> Result<StatusCode, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    sqlx::query(
        r#"
        UPDATE work_reports
        SET status = 'rejected',
            reviewed_by = $1,
            reviewed_at = NOW(),
            rejection_reason = $2
        WHERE id = $3
        AND status = 'submitted'
        "#
    )
    .bind(current_user.user_id)
    .bind(body.reason)
    .bind(report_id)
    .execute(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(StatusCode::OK)
}

/// ===========================================
/// HANDLER: GET ATTENDANCE SUMMARY
/// GET /api/kepala-cabang/attendance
/// ===========================================
pub async fn get_attendance_summary(
    State(pool): State<Pool<Postgres>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(query): Query<DateRangeQuery>,
) -> Result<Json<Vec<AttendanceSummary>>, AppError> {
    if current_user.role != UserRole::KepalaCabang {
        return Err(AppError::Forbidden);
    }

    let branch_id = current_user.branch_id
        .ok_or(AppError::Forbidden)?;

    let today = Utc::now().naive_utc().date();
    let start_date = query.start_date.unwrap_or(today - chrono::Duration::days(7));
    let end_date = query.end_date.unwrap_or(today);

    let summary: Vec<AttendanceSummary> = sqlx::query_as(
        r#"
        SELECT 
            a.date,
            COUNT(DISTINCT CASE WHEN a.status = 'present' THEN a.id END) as present,
            COUNT(DISTINCT CASE WHEN a.status = 'absent' THEN a.id END) as absent,
            COUNT(DISTINCT CASE WHEN lr.status = 'approved' THEN lr.id END) as on_leave,
            COUNT(DISTINCT CASE WHEN a.status = 'late' THEN a.id END) as late
        FROM generate_series($1::date, $2::date, '1 day'::interval) AS date
        LEFT JOIN attendance a ON a.date = date.date AND a.user_id IN (
            SELECT id FROM users WHERE branch_id = $3
        )
        LEFT JOIN leave_requests lr ON lr.user_id IN (
            SELECT id FROM users WHERE branch_id = $3
        ) AND date.date BETWEEN lr.start_date AND lr.end_date
        GROUP BY date.date
        ORDER BY date.date DESC
        "#
    )
    .bind(start_date)
    .bind(end_date)
    .bind(branch_id)
    .fetch_all(&pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(summary))
}
