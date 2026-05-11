use axum::{
    extract::{Query, State},
    http::StatusCode,
    response::Json,
    Extension,
};
use chrono::{Datelike, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{Pool, Sqlite};
use std::sync::Arc;

use crate::{
    AppState,
    config::Config,
    error::AppError,
    middleware::{CurrentUser, UserRole},
};

/// ===========================================
/// REQUEST/RESPONSE MODELS
/// ===========================================

#[derive(Debug, Deserialize)]
pub struct DashboardQuery {
    pub start_date: Option<NaiveDate>,
    pub end_date: Option<NaiveDate>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct DashboardMetrics {
    pub total_revenue: f64,
    pub total_orders: i64,
    pub total_customers: i64,
    pub pending_approvals: i64,
    pub branch_performance: Vec<BranchMetrics>,
    pub recent_activity: Vec<ActivityItem>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct BranchMetrics {
    pub id: String,
    pub name: String,
    pub code: String,
    pub revenue: f64,
    pub orders: i64,
    pub target: f64,
    pub achievement_percentage: f64,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct ActivityItem {
    pub id: String,
    pub user_name: String,
    pub action: String,
    pub details: String,
    pub timestamp: String,
    pub icon_type: String,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct SalesRanking {
    pub rank: i32,
    pub user_id: String,
    pub full_name: String,
    pub branch_name: String,
    pub sales_amount: f64,
    pub target: f64,
    pub achievement_percentage: f64,
    pub total_orders: i64,
    pub performance_level: String, // excellent, good, needs_improvement
}

/// ===========================================
/// HANDLER: GET OWNER DASHBOARD METRICS
/// GET /api/owner/dashboard
/// ===========================================
pub async fn get_dashboard_metrics(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(query): Query<DashboardQuery>,
) -> Result<Json<DashboardMetrics>, AppError> {
    let pool = &state.pool;
    // Verify user is owner
    if current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }

    // Default date range: current month
    let today = Utc::now().naive_utc().date();
    let start_date = query.start_date.unwrap_or_else(|| {
        NaiveDate::from_ymd_opt(today.year(), today.month(), 1).unwrap()
    });
    let end_date = query.end_date.unwrap_or(today);

    // Get total revenue
    let total_revenue: f64 = sqlx::query_scalar(
        r#"
        SELECT COALESCE(SUM(total_amount), 0.0)
        FROM payroll_records
        WHERE status = 'paid'
        AND created_at >= ?1
        AND created_at <= ?2
        "#
    )
    .bind(start_date)
    .bind(end_date)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get total employees
    let total_employees: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM users WHERE is_active = 1"
    )
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get pending approvals (work reports + job desk assignments)
    let pending_work_reports: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM work_reports WHERE status = 'submitted'"
    )
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let pending_jobdesk: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM jobdesk_assignments WHERE status = 'completed' AND approved_by IS NULL"
    )
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get branch performance
    let branch_metrics = get_branch_metrics(&pool, start_date, end_date).await?;

    // Get recent activity
    let recent_activity = get_recent_activity(&pool, 10).await?;

    let metrics = DashboardMetrics {
        total_revenue,
        total_orders: total_employees,
        total_customers: total_employees, // Using employee count as proxy
        pending_approvals: pending_work_reports + pending_jobdesk,
        branch_performance: branch_metrics,
        recent_activity,
    };

    Ok(Json(metrics))
}

/// ===========================================
/// HELPER: Get Branch Metrics
/// ===========================================
async fn get_branch_metrics(
    pool: &Pool<Sqlite>,
    start_date: NaiveDate,
    end_date: NaiveDate,
) -> Result<Vec<BranchMetrics>, AppError> {
    let branches: Vec<BranchMetrics> = sqlx::query_as(
        r#"
        SELECT 
            b.id,
            b.name,
            b.code,
            COALESCE(SUM(p.total_amount), 0.0) as revenue,
            COUNT(DISTINCT u.id) as orders,
            100000.0 as target, -- Example monthly target per branch
            0.0 as achievement_percentage
        FROM branches b
        LEFT JOIN users u ON u.branch_id = b.id AND u.is_active = 1
        LEFT JOIN payroll_records p ON p.user_id = u.id 
            AND p.status = 'paid'
            AND p.created_at >= ?1 
            AND p.created_at <= ?2
        WHERE b.is_active = 1
        GROUP BY b.id, b.name, b.code
        ORDER BY revenue DESC
        "#
    )
    .bind(start_date)
    .bind(end_date)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Calculate achievement percentage
    let branches: Vec<BranchMetrics> = branches
        .into_iter()
        .map(|mut b| {
            b.achievement_percentage = if b.target > 0.0 {
                (b.revenue / b.target) * 100.0
            } else {
                0.0
            };
            b
        })
        .collect();

    Ok(branches)
}

/// ===========================================
/// HELPER: Get Recent Activity
/// ===========================================
async fn get_recent_activity(
    pool: &Pool<Sqlite>,
    limit: i64,
) -> Result<Vec<ActivityItem>, AppError> {
    let activities: Vec<ActivityItem> = sqlx::query_as(
        r#"
        SELECT 
            id,
            username as user_name,
            'login' as action,
            'Logged in to system' as details,
            updated_at as timestamp,
            'login' as icon_type
        FROM users
        WHERE updated_at IS NOT NULL
        ORDER BY updated_at DESC
        LIMIT ?1
        "#
    )
    .bind(limit)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(activities)
}

/// ===========================================
/// HANDLER: GET SALES RANKING
/// GET /api/owner/sales-ranking
/// ===========================================
pub async fn get_sales_ranking(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(query): Query<DashboardQuery>,
) -> Result<Json<Vec<SalesRanking>>, AppError> {
    let pool = &state.pool;
    // Verify user is owner
    if current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }

    let today = Utc::now().naive_utc().date();
    let start_date = query.start_date.unwrap_or_else(|| {
        NaiveDate::from_ymd_opt(today.year(), today.month(), 1).unwrap()
    });
    let end_date = query.end_date.unwrap_or(today);

    let rankings: Vec<SalesRanking> = sqlx::query_as(
        r#"
        SELECT 
            ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(p.total_amount), 0.0) DESC) as rank,
            u.id as user_id,
            u.username as full_name,
            b.name as branch_name,
            COALESCE(SUM(p.total_amount), 0.0) as sales_amount,
            50000.0 as target, -- Example monthly sales target
            0.0 as achievement_percentage,
            COUNT(p.id) as total_orders,
            'needs_improvement' as performance_level
        FROM users u
        JOIN branches b ON b.id = u.branch_id
        LEFT JOIN payroll_records p ON p.user_id = u.id 
            AND p.status = 'paid'
            AND p.created_at >= ?1 
            AND p.created_at <= ?2
        WHERE u.role = 'sales'
        AND u.is_active = 1
        GROUP BY u.id, u.username, b.name
        ORDER BY sales_amount DESC
        "#
    )
    .bind(start_date)
    .bind(end_date)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Calculate achievement and performance level
    let rankings: Vec<SalesRanking> = rankings
        .into_iter()
        .map(|mut r| {
            r.achievement_percentage = if r.target > 0.0 {
                (r.sales_amount / r.target) * 100.0
            } else {
                0.0
            };
            
            r.performance_level = if r.achievement_percentage >= 100.0 {
                "excellent".to_string()
            } else if r.achievement_percentage >= 80.0 {
                "good".to_string()
            } else if r.achievement_percentage >= 60.0 {
                "average".to_string()
            } else {
                "needs_improvement".to_string()
            };
            
            r
        })
        .collect();

    Ok(Json(rankings))
}

/// ===========================================
/// HANDLER: GET BRANCH DETAIL
/// GET /api/owner/branches/:id
/// ===========================================
#[derive(Debug, Serialize, Clone)]
pub struct BranchDetail {
    pub id: String,
    pub code: String,
    pub name: String,
    pub address: String,
    pub phone: String,
    pub manager_id: Option<String>,
    pub manager_name: Option<String>,
    pub total_employees: i64,
    pub total_revenue: f64,
    pub total_orders: i64,
    pub pending_approvals: i64,
    pub attendance_rate: f64,
    pub recent_activity: Vec<ActivityItem>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct ManagerInfo {
    pub id: String,
    pub full_name: String,
    pub email: String,
    pub phone: String,
}

pub async fn get_branch_detail(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(branch_id): axum::extract::Path<String>,
) -> Result<Json<BranchDetail>, AppError> {
    let pool = &state.pool;
    // Verify user is owner
    if current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }

    let today = Utc::now().naive_utc().date();
    let start_date = NaiveDate::from_ymd_opt(today.year(), today.month(), 1).unwrap();

    // Get branch basic info
    let branch: (String, String, String, String, String, Option<String>, Option<String>) = sqlx::query_as(
        r#"
        SELECT 
            b.id,
            b.code,
            b.name,
            b.address,
            b.phone,
            b.manager_id,
            m.username as manager_name
        FROM branches b
        LEFT JOIN users m ON m.id = b.manager_id
        WHERE b.id = ?1
        "#
    )
    .bind(&branch_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get employee count
    let total_employees: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM users WHERE branch_id = ?1 AND is_active = 1"
    )
    .bind(&branch_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get total revenue for this branch
    let total_revenue: f64 = sqlx::query_scalar(
        r#"
        SELECT COALESCE(SUM(p.total_amount), 0.0)
        FROM payroll_records p
        JOIN users u ON u.id = p.user_id
        WHERE u.branch_id = ?1
        AND p.status = 'paid'
        AND p.created_at >= ?2
        "#
    )
    .bind(&branch_id)
    .bind(start_date)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get total orders (work reports completed)
    let total_orders: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*)
        FROM work_reports wr
        JOIN users u ON u.id = wr.user_id
        WHERE u.branch_id = ?1
        AND wr.status = 'approved'
        AND wr.created_at >= ?2
        "#
    )
    .bind(&branch_id)
    .bind(start_date)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get pending approvals
    let pending_work_reports: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*)
        FROM work_reports wr
        JOIN users u ON u.id = wr.user_id
        WHERE u.branch_id = ?1
        AND wr.status = 'submitted'
        "#
    )
    .bind(&branch_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let pending_jobdesk: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*)
        FROM jobdesk_assignments ja
        JOIN users u ON u.id = ja.user_id
        WHERE u.branch_id = ?1
        AND ja.status = 'completed'
        AND ja.approved_by IS NULL
        "#
    )
    .bind(&branch_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    // Get attendance rate
    let total_attendance: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*)
        FROM attendance a
        JOIN users u ON u.id = a.user_id
        WHERE u.branch_id = ?1
        AND a.date >= ?2
        "#
    )
    .bind(&branch_id)
    .bind(start_date)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let working_days = (today - start_date).num_days().max(1);
    let attendance_rate = if total_employees > 0 {
        (total_attendance as f64 / (total_employees as f64 * working_days as f64)) * 100.0
    } else {
        0.0
    };

    // Get recent activity for this branch
    let recent_activity: Vec<ActivityItem> = sqlx::query_as(
        r#"
        SELECT 
            u.id,
            u.username as user_name,
            'login' as action,
            'Logged in to system' as details,
            u.updated_at as timestamp,
            'login' as icon_type
        FROM users u
        WHERE u.branch_id = ?1
        AND u.updated_at IS NOT NULL
        ORDER BY u.updated_at DESC
        LIMIT 5
        "#
    )
    .bind(&branch_id)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let detail = BranchDetail {
        id: branch.0,
        code: branch.1,
        name: branch.2,
        address: branch.3,
        phone: branch.4,
        manager_id: branch.5,
        manager_name: branch.6,
        total_employees,
        total_revenue,
        total_orders,
        pending_approvals: pending_work_reports + pending_jobdesk,
        attendance_rate: attendance_rate.min(100.0),
        recent_activity,
    };

    Ok(Json(detail))
}

/// ===========================================
/// HANDLER: GET ALL BRANCHES
/// GET /api/owner/branches
/// ===========================================
#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct BranchListItem {
    pub id: String,
    pub code: String,
    pub name: String,
    pub address: String,
    pub phone: String,
    pub manager_id: Option<String>,
    pub total_employees: i64,
    pub total_revenue: f64,
}

pub async fn get_all_branches(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<BranchListItem>>, AppError> {
    let pool = &state.pool;
    // Verify user is owner
    if current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }

    let branches: Vec<BranchListItem> = sqlx::query_as(
        r#"
        SELECT 
            b.id,
            b.code,
            b.name,
            b.address,
            b.phone,
            b.manager_id,
            COUNT(DISTINCT u.id) as total_employees,
            COALESCE(SUM(p.total_amount), 0.0) as total_revenue
        FROM branches b
        LEFT JOIN users u ON u.branch_id = b.id AND u.is_active = 1
        LEFT JOIN payroll_records p ON p.user_id = u.id AND p.status = 'paid'
        GROUP BY b.id, b.code, b.name, b.address, b.phone, b.manager_id
        ORDER BY b.code
        "#
    )
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    Ok(Json(branches))
}
