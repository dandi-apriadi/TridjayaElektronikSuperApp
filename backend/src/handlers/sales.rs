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
/// SALES HANDLER - Sales Dashboard, Prospects, Campaigns
/// ============================================================

// ===================== MODELS =====================

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Prospect {
    pub id: String,
    pub user_id: String,
    pub name: String,
    pub phone: String,
    pub email: Option<String>,
    pub address: Option<String>,
    pub status: String, // new, contacted, negotiation, closed, lost
    pub source: Option<String>,
    pub product_interest: Option<String>,
    pub budget: Option<i64>,
    pub notes: Option<String>,
    pub last_contact: Option<DateTime<Utc>>,
    pub next_followup: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Campaign {
    pub id: String,
    pub user_id: String,
    pub name: String,
    pub description: Option<String>,
    pub target_amount: i64,
    pub achieved_amount: i64,
    pub status: String, // active, completed, cancelled
    pub start_date: DateTime<Utc>,
    pub end_date: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SalesDashboardMetrics {
    pub total_prospects: i32,
    pub prospects_by_status: ProspectSummary,
    pub monthly_target: i64,
    pub monthly_achieved: i64,
    pub conversion_rate: f64,
    pub active_campaigns: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProspectSummary {
    pub new: i32,
    pub contacted: i32,
    pub negotiation: i32,
    pub closed: i32,
    pub lost: i32,
}

// ===================== REQUESTS =====================

#[derive(Debug, Deserialize)]
pub struct CreateProspectRequest {
    pub name: String,
    pub phone: String,
    pub email: Option<String>,
    pub address: Option<String>,
    pub source: Option<String>,
    pub product_interest: Option<String>,
    pub budget: Option<i64>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateProspectRequest {
    pub name: Option<String>,
    pub phone: Option<String>,
    pub email: Option<String>,
    pub address: Option<String>,
    pub status: Option<String>,
    pub source: Option<String>,
    pub product_interest: Option<String>,
    pub budget: Option<i64>,
    pub notes: Option<String>,
    pub next_followup: Option<DateTime<Utc>>,
}

#[derive(Debug, Deserialize)]
pub struct CreateCampaignRequest {
    pub name: String,
    pub description: Option<String>,
    pub target_amount: i64,
    pub end_date: DateTime<Utc>,
}

// ===================== HANDLERS =====================

/// GET /api/sales/dashboard - Get sales dashboard metrics
pub async fn get_sales_dashboard(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<SalesDashboardMetrics>> {
    let pool = &state.pool;
    // Sales users see their own data, managers see branch data
    let results = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_as::<_, (i32, i32, i32, i32, i32, i32)>(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as new_count,
                    SUM(CASE WHEN status = 'contacted' THEN 1 ELSE 0 END) as contacted_count,
                    SUM(CASE WHEN status = 'negotiation' THEN 1 ELSE 0 END) as negotiation_count,
                    SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END) as closed_count,
                    SUM(CASE WHEN status = 'lost' THEN 1 ELSE 0 END) as lost_count
                FROM prospects"
            )
            .fetch_one(pool)
            .await
            .map_err(|_| AppError::NotFoundSimple)?
        },
        _ => {
            sqlx::query_as::<_, (i32, i32, i32, i32, i32, i32)>(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as new_count,
                    SUM(CASE WHEN status = 'contacted' THEN 1 ELSE 0 END) as contacted_count,
                    SUM(CASE WHEN status = 'negotiation' THEN 1 ELSE 0 END) as negotiation_count,
                    SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END) as closed_count,
                    SUM(CASE WHEN status = 'lost' THEN 1 ELSE 0 END) as lost_count
                FROM prospects
                WHERE user_id = ?"
            )
            .bind(&current_user.user_id)
            .fetch_one(pool)
            .await
            .map_err(|_| AppError::NotFoundSimple)?
        }
    };

    let (total, new_count, contacted, negotiation, closed, lost) = results;
    
    let conversion_rate = if total > 0 {
        (closed as f64 / total as f64) * 100.0
    } else {
        0.0
    };

    Ok(Json(SalesDashboardMetrics {
        total_prospects: total,
        prospects_by_status: ProspectSummary {
            new: new_count,
            contacted,
            negotiation,
            closed,
            lost,
        },
        monthly_target: 15,
        monthly_achieved: closed as i64,
        conversion_rate,
        active_campaigns: 0,
    }))
}

/// GET /api/sales/prospects - Get list of prospects
pub async fn list_prospects(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<Prospect>>> {
    let pool = &state.pool;
    let prospects = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_as::<_, Prospect>(
                "SELECT id, user_id, name, phone, email, address, status, source, product_interest, budget, notes, last_contact, next_followup, created_at, updated_at
                FROM prospects
                ORDER BY created_at DESC"
            )
            .fetch_all(pool)
            .await?
        },
        _ => {
            sqlx::query_as::<_, Prospect>(
                "SELECT id, user_id, name, phone, email, address, status, source, product_interest, budget, notes, last_contact, next_followup, created_at, updated_at
                FROM prospects
                WHERE user_id = ?
                ORDER BY created_at DESC"
            )
            .bind(&current_user.user_id)
            .fetch_all(pool)
            .await?
        }
    };

    Ok(Json(prospects))
}

/// GET /api/sales/prospects/:id - Get prospect detail
pub async fn get_prospect(
    State(state): State<Arc<AppState>>,
    Path(prospect_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Prospect>> {
    let pool = &state.pool;
    let prospect = sqlx::query_as::<_, Prospect>(
        "SELECT id, user_id, name, phone, email, address, status, source, product_interest, budget, notes, last_contact, next_followup, created_at, updated_at
        FROM prospects
        WHERE id = ? AND user_id = ?"
    )
    .bind(&prospect_id)
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFoundSimple)?;

    Ok(Json(prospect))
}

/// POST /api/sales/prospects - Create new prospect
pub async fn create_prospect(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateProspectRequest>,
) -> AppResult<(StatusCode, Json<serde_json::Value>)> {
    let pool = &state.pool;
    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO prospects (id, user_id, name, phone, email, address, status, source, product_interest, budget, notes, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&req.name)
    .bind(&req.phone)
    .bind(&req.email)
    .bind(&req.address)
    .bind("new")
    .bind(&req.source)
    .bind(&req.product_interest)
    .bind(&req.budget)
    .bind(&req.notes)
    .bind(&now)
    .bind(&now)
    .execute(pool)
    .await?;

    Ok((StatusCode::CREATED, Json(serde_json::json!({"id": id}))))
}

/// PUT /api/sales/prospects/:id - Update prospect
pub async fn update_prospect(
    State(state): State<Arc<AppState>>,
    Path(prospect_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<UpdateProspectRequest>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    // Check ownership
    let prospect = sqlx::query_scalar::<_, String>("SELECT user_id FROM prospects WHERE id = ?")
        .bind(&prospect_id)
        .fetch_one(pool)
        .await
        .map_err(|_| AppError::NotFoundSimple)?;

    if prospect != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    let now = Utc::now();

    sqlx::query(
        "UPDATE prospects SET
            name = COALESCE(?, name),
            phone = COALESCE(?, phone),
            email = COALESCE(?, email),
            address = COALESCE(?, address),
            status = COALESCE(?, status),
            source = COALESCE(?, source),
            product_interest = COALESCE(?, product_interest),
            budget = COALESCE(?, budget),
            notes = COALESCE(?, notes),
            next_followup = COALESCE(?, next_followup),
            last_contact = ?,
            updated_at = ?
        WHERE id = ?"
    )
    .bind(&req.name)
    .bind(&req.phone)
    .bind(&req.email)
    .bind(&req.address)
    .bind(&req.status)
    .bind(&req.source)
    .bind(&req.product_interest)
    .bind(&req.budget)
    .bind(&req.notes)
    .bind(&req.next_followup)
    .bind(&now)
    .bind(&now)
    .bind(&prospect_id)
    .execute(pool)
    .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// DELETE /api/sales/prospects/:id - Delete prospect
pub async fn delete_prospect(
    State(state): State<Arc<AppState>>,
    Path(prospect_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    let prospect = sqlx::query_scalar::<_, String>("SELECT user_id FROM prospects WHERE id = ?")
        .bind(&prospect_id)
        .fetch_one(pool)
        .await
        .map_err(|_| AppError::NotFoundSimple)?;

    if prospect != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    sqlx::query("DELETE FROM prospects WHERE id = ?")
        .bind(&prospect_id)
        .execute(pool)
        .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// GET /api/sales/campaigns - Get list of campaigns
pub async fn list_campaigns(
    State(state): State<Arc<AppState>>,
    Extension(_current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<Campaign>>> {
    let pool = &state.pool;
    let campaigns = sqlx::query_as::<_, Campaign>(
        "SELECT id, user_id, name, description, target_amount, achieved_amount, status, start_date, end_date, created_at
        FROM campaigns
        ORDER BY start_date DESC"
    )
    .fetch_all(pool)
    .await?;

    Ok(Json(campaigns))
}

/// GET /api/sales/reports - Get sales performance report
pub async fn get_sales_report(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    let closed_count = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(*) FROM prospects WHERE status = 'closed'"
            )
            .fetch_one(pool)
            .await?
        },
        _ => {
            sqlx::query_scalar::<_, i64>(
                "SELECT COUNT(*) FROM prospects WHERE status = 'closed' AND user_id = ?"
            )
            .bind(&current_user.user_id)
            .fetch_one(pool)
            .await?
        }
    };

    Ok(Json(serde_json::json!({
        "total_closed": closed_count,
        "target": 15,
        "achievement_percentage": ((closed_count as f64 / 15.0) * 100.0).round() as i32,
    })))
}
