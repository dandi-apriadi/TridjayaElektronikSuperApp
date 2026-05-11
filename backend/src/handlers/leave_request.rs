use axum::{
    extract::{Path, Query, State},
    http::StatusCode,
    response::Json,
    Extension,
};
use chrono::{NaiveDate, Utc};
use serde::{Deserialize, Serialize};
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

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct LeaveRequest {
    pub id: String,
    pub user_id: String,
    pub branch_id: String,
    pub reason: String,
    pub start_date: String,
    pub end_date: String,
    pub status: String, // pending, approved, rejected
    pub created_at: String,
    #[sqlx(skip)]
    pub user_name: Option<String>,
    #[sqlx(skip)]
    pub days_count: Option<i32>,
}

#[derive(Debug, Deserialize)]
pub struct CreateLeaveRequestBody {
    pub start_date: String, // YYYY-MM-DD
    pub end_date: String,   // YYYY-MM-DD
    pub reason: String,
}

#[derive(Debug, Deserialize)]
pub struct ApproveRejectBody {
    pub notes: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct LeaveRequestResponse {
    pub id: String,
    pub user_id: String,
    pub user_name: String,
    pub branch_id: String,
    pub reason: String,
    pub start_date: String,
    pub end_date: String,
    pub days_count: i32,
    pub status: String,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct GetLeaveRequestsQuery {
    pub status: Option<String>,
    pub start_date: Option<String>,
    pub end_date: Option<String>,
}

// ============================================
// HANDLER: GET MY LEAVE REQUESTS
// GET /api/leave-requests/my
// ============================================
pub async fn get_my_leave_requests(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(query): Query<GetLeaveRequestsQuery>,
) -> AppResult<Json<Vec<LeaveRequestResponse>>> {
    let pool = &state.pool;

    let mut sql = String::from(
        r#"
        SELECT lr.id, lr.user_id, lr.branch_id, lr.reason, lr.start_date, 
               lr.end_date, lr.status, lr.created_at, u.username as user_name
        FROM leave_requests lr
        LEFT JOIN users u ON u.id = lr.user_id
        WHERE lr.user_id = ?1
        "#,
    );

    if let Some(status) = &query.status {
        sql.push_str(" AND lr.status = ?");
    }

    sql.push_str(" ORDER BY lr.created_at DESC");

    let mut query_builder = sqlx::query_as::<_, (
        String,
        String,
        String,
        String,
        String,
        String,
        String,
        String,
        Option<String>,
    )>(sql.as_str()).bind(&current_user.user_id);

    if let Some(status) = &query.status {
        query_builder = query_builder.bind(status);
    }

    let results = query_builder.fetch_all(pool).await.map_err(|e| {
        eprintln!("DB Error: {}", e);
        AppError::Database(e)
    })?;

    let responses: Vec<LeaveRequestResponse> = results
        .into_iter()
        .map(|(id, user_id, branch_id, reason, start_date, end_date, status, created_at, user_name)| {
            let days_count = calculate_days_between(&start_date, &end_date);
            LeaveRequestResponse {
                id,
                user_id,
                user_name: user_name.unwrap_or_default(),
                branch_id,
                reason,
                start_date,
                end_date,
                days_count,
                status,
                created_at,
            }
        })
        .collect();

    Ok(Json(responses))
}

// ============================================
// HANDLER: GET ALL LEAVE REQUESTS (ADMIN/PIC)
// GET /api/leave-requests
// ============================================
pub async fn get_all_leave_requests(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(query): Query<GetLeaveRequestsQuery>,
) -> AppResult<Json<Vec<LeaveRequestResponse>>> {
    let pool = &state.pool;

    // Only Kepala Cabang, PIC, Admin, and Owner can view all
    if ![
        UserRole::KepalaCabang,
        UserRole::PicPelaporan,
        UserRole::Admin,
        UserRole::Owner,
    ]
    .contains(&current_user.role)
    {
        return Err(AppError::Forbidden);
    }

    let mut sql = String::from(
        r#"
        SELECT lr.id, lr.user_id, lr.branch_id, lr.reason, lr.start_date, 
               lr.end_date, lr.status, lr.created_at, u.username as user_name
        FROM leave_requests lr
        LEFT JOIN users u ON u.id = lr.user_id
        WHERE 1=1
        "#,
    );

    if let Some(status) = &query.status {
        sql.push_str(" AND lr.status = ?");
    }

    // If Kepala Cabang, only show for their branch
    if current_user.role == UserRole::KepalaCabang {
        sql.push_str(" AND lr.branch_id = ?");
    }

    sql.push_str(" ORDER BY lr.created_at DESC");

    let results = if current_user.role == UserRole::KepalaCabang {
        let mut qb = sqlx::query_as::<_, (
            String,
            String,
            String,
            String,
            String,
            String,
            String,
            String,
            Option<String>,
        )>(sql.as_str());

        if let Some(status) = &query.status {
            qb = qb.bind(status);
        }

        if let Some(branch_id) = &current_user.branch_id {
            qb = qb.bind(branch_id);
        }

        qb.fetch_all(pool).await.map_err(|e| AppError::Database(e))?
    } else {
        let mut qb = sqlx::query_as::<_, (
            String,
            String,
            String,
            String,
            String,
            String,
            String,
            String,
            Option<String>,
        )>(sql.as_str());

        if let Some(status) = &query.status {
            qb = qb.bind(status);
        }

        qb.fetch_all(pool).await.map_err(|e| AppError::Database(e))?
    };

    let responses: Vec<LeaveRequestResponse> = results
        .into_iter()
        .map(|(id, user_id, branch_id, reason, start_date, end_date, status, created_at, user_name)| {
            let days_count = calculate_days_between(&start_date, &end_date);
            LeaveRequestResponse {
                id,
                user_id,
                user_name: user_name.unwrap_or_default(),
                branch_id,
                reason,
                start_date,
                end_date,
                days_count,
                status,
                created_at,
            }
        })
        .collect();

    Ok(Json(responses))
}

// ============================================
// HANDLER: GET LEAVE REQUEST DETAIL
// GET /api/leave-requests/:id
// ============================================
pub async fn get_leave_request_detail(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
) -> AppResult<Json<LeaveRequestResponse>> {
    let pool = &state.pool;

    let result = sqlx::query_as::<_, (
        String,
        String,
        String,
        String,
        String,
        String,
        String,
        String,
        Option<String>,
    )>(
        r#"
        SELECT lr.id, lr.user_id, lr.branch_id, lr.reason, lr.start_date, 
               lr.end_date, lr.status, lr.created_at, u.username as user_name
        FROM leave_requests lr
        LEFT JOIN users u ON u.id = lr.user_id
        WHERE lr.id = ?1
        "#,
    )
    .bind(&id)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::Database(e))?
    .ok_or(AppError::NotFound("Not found".into()))?;

    let (
        id,
        user_id,
        branch_id,
        reason,
        start_date,
        end_date,
        status,
        created_at,
        user_name,
    ) = result;

    // Authorization: user can only view their own, or if manager/admin
    if current_user.user_id != user_id
        && ![
            UserRole::KepalaCabang,
            UserRole::PicPelaporan,
            UserRole::Admin,
            UserRole::Owner,
        ]
        .contains(&current_user.role)
    {
        return Err(AppError::Forbidden);
    }

    let days_count = calculate_days_between(&start_date, &end_date);

    Ok(Json(LeaveRequestResponse {
        id,
        user_id,
        user_name: user_name.unwrap_or_default(),
        branch_id,
        reason,
        start_date,
        end_date,
        days_count,
        status,
        created_at,
    }))
}

// ============================================
// HANDLER: CREATE LEAVE REQUEST
// POST /api/leave-requests
// ============================================
pub async fn create_leave_request(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(body): Json<CreateLeaveRequestBody>,
) -> AppResult<(StatusCode, Json<LeaveRequestResponse>)> {
    let pool = &state.pool;

    // Validate dates
    let start = NaiveDate::parse_from_str(&body.start_date, "%Y-%m-%d")
        .map_err(|_| AppError::BadRequest("Invalid start_date format".into()))?;
    let end =
        NaiveDate::parse_from_str(&body.end_date, "%Y-%m-%d")
            .map_err(|_| AppError::BadRequest("Invalid end_date format".into()))?;

    if end < start {
        return Err(AppError::BadRequest(
            "end_date must be after or equal to start_date".into(),
        ));
    }

    // Check for overlapping leave requests
    let overlap_count: i64 = sqlx::query_scalar(
        r#"
        SELECT COUNT(*) FROM leave_requests
        WHERE user_id = ?1
        AND status IN ('pending', 'approved')
        AND ?2 <= end_date
        AND ?3 >= start_date
        "#,
    )
    .bind(&current_user.user_id)
    .bind(&body.start_date)
    .bind(&body.end_date)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    if overlap_count > 0 {
        return Err(AppError::BadRequest(
            "Sudah ada pengajuan leave untuk periode ini".into(),
        ));
    }

    let id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    let user = sqlx::query_as::<_, (String, String)>(
        "SELECT id, username FROM users WHERE id = ?1",
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    sqlx::query(
        r#"
        INSERT INTO leave_requests (id, user_id, branch_id, reason, start_date, end_date, status, created_at)
        VALUES (?1, ?2, ?3, ?4, ?5, ?6, 'pending', ?7)
        "#,
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&current_user.branch_id.clone().unwrap_or_default())
    .bind(&body.reason)
    .bind(&body.start_date)
    .bind(&body.end_date)
    .bind(&now)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;

    let days_count = calculate_days_between(&body.start_date, &body.end_date);

    Ok((
        StatusCode::CREATED,
        Json(LeaveRequestResponse {
            id,
            user_id: current_user.user_id,
            user_name: user.1,
            branch_id: current_user.branch_id.clone().unwrap_or_default(),
            reason: body.reason,
            start_date: body.start_date,
            end_date: body.end_date,
            days_count,
            status: "pending".to_string(),
            created_at: now,
        }),
    ))
}

// ============================================
// HANDLER: APPROVE LEAVE REQUEST
// POST /api/leave-requests/:id/approve
// ============================================
pub async fn approve_leave_request(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
    Json(_body): Json<ApproveRejectBody>,
) -> AppResult<Json<LeaveRequestResponse>> {
    let pool = &state.pool;

    // Only Kepala Cabang, PIC, Admin can approve
    if ![
        UserRole::KepalaCabang,
        UserRole::PicPelaporan,
        UserRole::Admin,
        UserRole::Owner,
    ]
    .contains(&current_user.role)
    {
        return Err(AppError::Forbidden);
    }

    // Get leave request and verify access
    let (user_id, branch_id, reason, start_date, end_date, status, created_at, user_name) =
        sqlx::query_as::<_, (String, String, String, String, String, String, String, Option<String>)>(
            r#"
            SELECT lr.user_id, lr.branch_id, lr.reason, lr.start_date, lr.end_date,
                   lr.status, lr.created_at, u.username
            FROM leave_requests lr
            LEFT JOIN users u ON u.id = lr.user_id
            WHERE lr.id = ?1
            "#,
        )
        .bind(&id)
        .fetch_optional(pool)
        .await
        .map_err(|e| AppError::Database(e))?
        .ok_or(AppError::NotFound("Not found".into()))?;

    // Kepala Cabang can only approve for their branch
    if current_user.role == UserRole::KepalaCabang
        && current_user.branch_id.as_ref() != Some(&branch_id)
    {
        return Err(AppError::Forbidden);
    }

    // Update status
    sqlx::query("UPDATE leave_requests SET status = 'approved' WHERE id = ?1")
        .bind(&id)
        .execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;

    let days_count = calculate_days_between(&start_date, &end_date);

    Ok(Json(LeaveRequestResponse {
        id,
        user_id,
        user_name: user_name.unwrap_or_default(),
        branch_id,
        reason,
        start_date,
        end_date,
        days_count,
        status: "approved".to_string(),
        created_at,
    }))
}

// ============================================
// HANDLER: REJECT LEAVE REQUEST
// POST /api/leave-requests/:id/reject
// ============================================
pub async fn reject_leave_request(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
    Json(_body): Json<ApproveRejectBody>,
) -> AppResult<Json<LeaveRequestResponse>> {
    let pool = &state.pool;

    // Only Kepala Cabang, PIC, Admin can reject
    if ![
        UserRole::KepalaCabang,
        UserRole::PicPelaporan,
        UserRole::Admin,
        UserRole::Owner,
    ]
    .contains(&current_user.role)
    {
        return Err(AppError::Forbidden);
    }

    // Get leave request and verify access
    let (user_id, branch_id, reason, start_date, end_date, status, created_at, user_name) =
        sqlx::query_as::<_, (String, String, String, String, String, String, String, Option<String>)>(
            r#"
            SELECT lr.user_id, lr.branch_id, lr.reason, lr.start_date, lr.end_date,
                   lr.status, lr.created_at, u.username
            FROM leave_requests lr
            LEFT JOIN users u ON u.id = lr.user_id
            WHERE lr.id = ?1
            "#,
        )
        .bind(&id)
        .fetch_optional(pool)
        .await
        .map_err(|e| AppError::Database(e))?
        .ok_or(AppError::NotFound("Not found".into()))?;

    // Kepala Cabang can only reject for their branch
    if current_user.role == UserRole::KepalaCabang
        && current_user.branch_id.as_ref() != Some(&branch_id)
    {
        return Err(AppError::Forbidden);
    }

    // Update status
    sqlx::query("UPDATE leave_requests SET status = 'rejected' WHERE id = ?1")
        .bind(&id)
        .execute(pool)
        .await
        .map_err(|e| AppError::Database(e))?;

    let days_count = calculate_days_between(&start_date, &end_date);

    Ok(Json(LeaveRequestResponse {
        id,
        user_id,
        user_name: user_name.unwrap_or_default(),
        branch_id,
        reason,
        start_date,
        end_date,
        days_count,
        status: "rejected".to_string(),
        created_at,
    }))
}

// ============================================
// HELPER FUNCTIONS
// ============================================

fn calculate_days_between(start: &str, end: &str) -> i32 {
    if let (Ok(start_date), Ok(end_date)) =
        (
            NaiveDate::parse_from_str(start, "%Y-%m-%d"),
            NaiveDate::parse_from_str(end, "%Y-%m-%d"),
        )
    {
        let duration = end_date.signed_duration_since(start_date);
        (duration.num_days() + 1) as i32 // Include both start and end date
    } else {
        0
    }
}
