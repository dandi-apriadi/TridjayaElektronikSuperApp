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
/// CRM HANDLER - Customer Relationship Management
/// ============================================================

// ===================== MODELS =====================

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct CrmCustomer {
    pub id: String,
    pub user_id: String,
    pub name: String,
    pub phone: String,
    pub email: Option<String>,
    pub address: Option<String>,
    pub status: String, // hot, warm, cold, converted, lost
    pub source: Option<String>,
    pub budget: Option<i64>,
    pub interest: Option<String>,
    pub notes: Option<String>,
    pub last_interaction: Option<DateTime<Utc>>,
    pub next_followup: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct CustomerInteraction {
    pub id: String,
    pub customer_id: String,
    pub user_id: String,
    pub interaction_type: String, // call, email, meeting, message
    pub notes: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CrmStatistics {
    pub total_customers: i32,
    pub hot_prospects: i32,
    pub warm_prospects: i32,
    pub cold_prospects: i32,
    pub converted: i32,
    pub lost: i32,
    pub conversion_rate: f64,
    pub total_interactions: i32,
}

// ===================== REQUESTS =====================

#[derive(Debug, Deserialize)]
pub struct CreateCustomerRequest {
    pub name: String,
    pub phone: String,
    pub email: Option<String>,
    pub address: Option<String>,
    pub source: Option<String>,
    pub interest: Option<String>,
    pub budget: Option<i64>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct UpdateCustomerRequest {
    pub name: Option<String>,
    pub phone: Option<String>,
    pub email: Option<String>,
    pub address: Option<String>,
    pub status: Option<String>,
    pub source: Option<String>,
    pub interest: Option<String>,
    pub budget: Option<i64>,
    pub notes: Option<String>,
    pub next_followup: Option<DateTime<Utc>>,
}

#[derive(Debug, Deserialize)]
pub struct CreateInteractionRequest {
    pub interaction_type: String,
    pub notes: String,
}

// ===================== HANDLERS =====================

/// GET /api/crm/customers - Get list of customers
pub async fn list_customers(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<CrmCustomer>>> {
    let pool = &state.pool;
    let customers = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_as::<_, CrmCustomer>(
                "SELECT id, user_id, name, phone, email, address, status, source, budget, interest, notes, last_interaction, next_followup, created_at, updated_at
                FROM crm_customers
                ORDER BY last_interaction DESC"
            )
            .fetch_all(pool)
            .await?
        },
        _ => {
            sqlx::query_as::<_, CrmCustomer>(
                "SELECT id, user_id, name, phone, email, address, status, source, budget, interest, notes, last_interaction, next_followup, created_at, updated_at
                FROM crm_customers
                WHERE user_id = ?
                ORDER BY last_interaction DESC"
            )
            .bind(&current_user.user_id)
            .fetch_all(pool)
            .await?
        }
    };

    Ok(Json(customers))
}

/// GET /api/crm/customers/:id - Get customer detail with interaction history
pub async fn get_customer(
    State(state): State<Arc<AppState>>,
    Path(customer_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<serde_json::Value>> {
    let pool = &state.pool;
    let customer = sqlx::query_as::<_, CrmCustomer>(
        "SELECT id, user_id, name, phone, email, address, status, source, budget, interest, notes, last_interaction, next_followup, created_at, updated_at
        FROM crm_customers
        WHERE id = ? AND (user_id = ? OR EXISTS(SELECT 1 FROM users WHERE role IN ('Owner', 'Admin')))"
    )
    .bind(&customer_id)
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await?;

    let interactions = sqlx::query_as::<_, CustomerInteraction>(
        "SELECT id, customer_id, user_id, interaction_type, notes, created_at
        FROM customer_interactions
        WHERE customer_id = ?
        ORDER BY created_at DESC"
    )
    .bind(&customer_id)
    .fetch_all(pool)
    .await?;

    Ok(Json(serde_json::json!({
        "customer": customer,
        "interactions": interactions,
    })))
}

/// POST /api/crm/customers - Create new customer
pub async fn create_customer(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateCustomerRequest>,
) -> AppResult<(StatusCode, Json<serde_json::Value>)> {
    let pool = &state.pool;
    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO crm_customers (id, user_id, name, phone, email, address, status, source, budget, interest, notes, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&req.name)
    .bind(&req.phone)
    .bind(&req.email)
    .bind(&req.address)
    .bind("cold")
    .bind(&req.source)
    .bind(&req.budget)
    .bind(&req.interest)
    .bind(&req.notes)
    .bind(&now)
    .bind(&now)
    .execute(pool)
    .await?;

    Ok((StatusCode::CREATED, Json(serde_json::json!({"id": id}))))
}

/// PUT /api/crm/customers/:id - Update customer
pub async fn update_customer(
    State(state): State<Arc<AppState>>,
    Path(customer_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<UpdateCustomerRequest>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    let customer = sqlx::query_scalar::<_, String>("SELECT user_id FROM crm_customers WHERE id = ?")
        .bind(&customer_id)
        .fetch_one(pool)
        .await?;

    if customer != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    let now = Utc::now();

    sqlx::query(
        "UPDATE crm_customers SET
            name = COALESCE(?, name),
            phone = COALESCE(?, phone),
            email = COALESCE(?, email),
            address = COALESCE(?, address),
            status = COALESCE(?, status),
            source = COALESCE(?, source),
            budget = COALESCE(?, budget),
            interest = COALESCE(?, interest),
            notes = COALESCE(?, notes),
            next_followup = COALESCE(?, next_followup),
            last_interaction = ?,
            updated_at = ?
        WHERE id = ?"
    )
    .bind(&req.name)
    .bind(&req.phone)
    .bind(&req.email)
    .bind(&req.address)
    .bind(&req.status)
    .bind(&req.source)
    .bind(&req.budget)
    .bind(&req.interest)
    .bind(&req.notes)
    .bind(&req.next_followup)
    .bind(&now)
    .bind(&now)
    .bind(&customer_id)
    .execute(pool)
    .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// DELETE /api/crm/customers/:id - Delete customer
pub async fn delete_customer(
    State(state): State<Arc<AppState>>,
    Path(customer_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<StatusCode> {
    let pool = &state.pool;
    let customer = sqlx::query_scalar::<_, String>("SELECT user_id FROM crm_customers WHERE id = ?")
        .bind(&customer_id)
        .fetch_one(pool)
        .await?;

    if customer != current_user.user_id {
        return Err(AppError::Forbidden);
    }

    sqlx::query("DELETE FROM crm_customers WHERE id = ?")
        .bind(&customer_id)
        .execute(pool)
        .await?;

    Ok(StatusCode::NO_CONTENT)
}

/// POST /api/crm/customers/:id/interactions - Log customer interaction
pub async fn create_interaction(
    State(state): State<Arc<AppState>>,
    Path(customer_id): Path<String>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CreateInteractionRequest>,
) -> AppResult<(StatusCode, Json<serde_json::Value>)> {
    let pool = &state.pool;
    // Verify customer ownership
    let _ = sqlx::query_scalar::<_, String>("SELECT user_id FROM crm_customers WHERE id = ?")
        .bind(&customer_id)
        .fetch_one(pool)
        .await?;

    let id = Uuid::new_v4().to_string();
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO customer_interactions (id, customer_id, user_id, interaction_type, notes, created_at)
        VALUES (?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&customer_id)
    .bind(&current_user.user_id)
    .bind(&req.interaction_type)
    .bind(&req.notes)
    .bind(&now)
    .execute(pool)
    .await?;

    // Update customer last_interaction
    sqlx::query("UPDATE crm_customers SET last_interaction = ? WHERE id = ?")
        .bind(&now)
        .bind(&customer_id)
        .execute(pool)
        .await?;

    Ok((StatusCode::CREATED, Json(serde_json::json!({"id": id}))))
}

/// GET /api/crm/interactions/:customer_id - Get customer interactions
pub async fn get_interactions(
    State(state): State<Arc<AppState>>,
    Path(customer_id): Path<String>,
    Extension(_current_user): Extension<CurrentUser>,
) -> AppResult<Json<Vec<CustomerInteraction>>> {
    let pool = &state.pool;
    let interactions = sqlx::query_as::<_, CustomerInteraction>(
        "SELECT id, customer_id, user_id, interaction_type, notes, created_at
        FROM customer_interactions
        WHERE customer_id = ?
        ORDER BY created_at DESC"
    )
    .bind(&customer_id)
    .fetch_all(pool)
    .await?;

    Ok(Json(interactions))
}

/// GET /api/crm/statistics - Get CRM statistics
pub async fn get_crm_statistics(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<CrmStatistics>> {
    let pool = &state.pool;
    let stats = match current_user.role {
        UserRole::Owner | UserRole::Admin => {
            sqlx::query_as::<_, (i32, i32, i32, i32, i32, i32, i32)>(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'hot' THEN 1 ELSE 0 END) as hot,
                    SUM(CASE WHEN status = 'warm' THEN 1 ELSE 0 END) as warm,
                    SUM(CASE WHEN status = 'cold' THEN 1 ELSE 0 END) as cold,
                    SUM(CASE WHEN status = 'converted' THEN 1 ELSE 0 END) as converted,
                    SUM(CASE WHEN status = 'lost' THEN 1 ELSE 0 END) as lost,
                    (SELECT COUNT(*) FROM customer_interactions) as interactions
                FROM crm_customers"
            )
            .fetch_one(pool)
            .await?
        },
        _ => {
            sqlx::query_as::<_, (i32, i32, i32, i32, i32, i32, i32)>(
                "SELECT
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'hot' THEN 1 ELSE 0 END) as hot,
                    SUM(CASE WHEN status = 'warm' THEN 1 ELSE 0 END) as warm,
                    SUM(CASE WHEN status = 'cold' THEN 1 ELSE 0 END) as cold,
                    SUM(CASE WHEN status = 'converted' THEN 1 ELSE 0 END) as converted,
                    SUM(CASE WHEN status = 'lost' THEN 1 ELSE 0 END) as lost,
                    (SELECT COUNT(*) FROM customer_interactions WHERE user_id = ?) as interactions
                FROM crm_customers
                WHERE user_id = ?"
            )
            .bind(&current_user.user_id)
            .bind(&current_user.user_id)
            .fetch_one(pool)
            .await?
        }
    };

    let (total, hot, warm, cold, converted, lost, interactions) = stats;
    let conversion_rate = if total > 0 {
        (converted as f64 / total as f64) * 100.0
    } else {
        0.0
    };

    Ok(Json(CrmStatistics {
        total_customers: total,
        hot_prospects: hot,
        warm_prospects: warm,
        cold_prospects: cold,
        converted,
        lost,
        conversion_rate,
        total_interactions: interactions,
    }))
}
