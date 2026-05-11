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
pub struct InventoryItem {
    pub id: String,
    pub branch_id: String,
    pub name: String,
    pub category: String,
    pub sku: Option<String>,
    pub unit: String,
    pub current_stock: i32,
    pub minimum_stock: i32,
    pub maximum_stock: i32,
    pub price_per_unit: Option<f64>,
    pub notes: Option<String>,
    pub is_active: bool,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct StockTransaction {
    pub id: String,
    pub item_id: String,
    pub branch_id: String,
    pub user_id: String,
    pub r#type: String, // add, remove, adjustment
    pub quantity: i32,
    pub old_quantity: Option<i32>,
    pub new_quantity: Option<i32>,
    pub reason: Option<String>,
    pub reference_id: Option<String>,
    pub photo_url: Option<String>,
    pub notes: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct InventoryAlert {
    pub id: String,
    pub item_id: String,
    pub branch_id: String,
    pub alert_type: String, // low_stock, high_stock, out_of_stock
    pub current_quantity: i32,
    pub threshold: i32,
    pub severity: String,
    pub is_resolved: bool,
    pub created_at: String,
    pub resolved_at: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AddStockRequest {
    pub item_id: String,
    pub quantity: i32,
    pub reason: Option<String>,
    pub reference_id: Option<String>,
    pub photo_url: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct RemoveStockRequest {
    pub item_id: String,
    pub quantity: i32,
    pub reason: Option<String>,
    pub reference_id: Option<String>,
    pub photo_url: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct InventoryStats {
    pub total_items: i64,
    pub total_stock_value: f64,
    pub low_stock_items: i64,
    pub out_of_stock_items: i64,
    pub alerts_count: i64,
}

#[derive(Debug, Serialize)]
pub struct StockAddResponse {
    pub success: bool,
    pub message: String,
    pub item: InventoryItem,
    pub transaction: StockTransaction,
}

#[derive(Debug, Serialize)]
pub struct StockRemoveResponse {
    pub success: bool,
    pub message: String,
    pub item: InventoryItem,
    pub transaction: StockTransaction,
}

// ============================================
// GET INVENTORY ITEMS (Admin)
// GET /api/inventory/items
// ============================================
pub async fn get_inventory_items(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<Vec<InventoryItem>>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    let mut query = String::from("SELECT * FROM inventory_items WHERE 1=1");
    
    // Filter by branch (admin sees only their branch, owner sees all)
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            query.push_str(" AND branch_id = ?");
        }
    }
    
    // Filter by category
    if let Some(category) = params.get("category") {
        query.push_str(" AND category = ?");
    }
    
    // Filter by status
    if let Some(active) = params.get("active") {
        query.push_str(" AND is_active = ?");
    }
    
    query.push_str(" ORDER BY name ASC");
    
    let mut q = sqlx::query_as::<_, InventoryItem>(&query);
    
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            q = q.bind(branch_id);
        }
    }
    
    if let Some(category) = params.get("category") {
        q = q.bind(category);
    }
    
    if let Some(active) = params.get("active") {
        let is_active = active == "true";
        q = q.bind(if is_active { 1 } else { 0 });
    }
    
    let items: Vec<InventoryItem> = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(items))
}

// ============================================
// GET INVENTORY ITEM DETAIL
// GET /api/inventory/items/:id
// ============================================
pub async fn get_inventory_item_detail(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    axum::extract::Path(id): axum::extract::Path<String>,
) -> AppResult<Json<InventoryItem>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    let item: InventoryItem = sqlx::query_as(
        "SELECT * FROM inventory_items WHERE id = ?1"
    )
    .bind(&id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Item tidak ditemukan".to_string()))?;
    
    // Check branch access
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            if item.branch_id != *branch_id {
                return Err(AppError::Forbidden);
            }
        }
    }
    
    Ok(Json(item))
}

// ============================================
// ADD STOCK (Admin)
// POST /api/inventory/stock/add
// ============================================
pub async fn add_stock(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<AddStockRequest>,
) -> AppResult<Json<StockAddResponse>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    if req.quantity <= 0 {
        return Err(AppError::BadRequest("Jumlah harus lebih dari 0".to_string()));
    }
    
    // Get current item
    let current_item: (i32,) = sqlx::query_as(
        "SELECT current_stock FROM inventory_items WHERE id = ?1"
    )
    .bind(&req.item_id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Item tidak ditemukan".to_string()))?;
    
    let old_quantity = current_item.0;
    let new_quantity = old_quantity + req.quantity;
    
    // Update inventory
    sqlx::query(
        "UPDATE inventory_items SET current_stock = ?1, updated_at = ?2 WHERE id = ?3"
    )
    .bind(new_quantity)
    .bind(Utc::now().to_rfc3339())
    .bind(&req.item_id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // Create transaction record
    let transaction_id = Uuid::new_v4().to_string();
    let branch_id = current_user.branch_id
        .ok_or(AppError::BadRequest("User tidak memiliki cabang".to_string()))?;
    
    sqlx::query(
        r#"
        INSERT INTO stock_transactions (
            id, item_id, branch_id, user_id, type, quantity,
            old_quantity, new_quantity, reason, reference_id, photo_url, created_at
        ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12)
        "#
    )
    .bind(&transaction_id)
    .bind(&req.item_id)
    .bind(&branch_id)
    .bind(&current_user.user_id)
    .bind("add")
    .bind(req.quantity)
    .bind(old_quantity)
    .bind(new_quantity)
    .bind(&req.reason)
    .bind(&req.reference_id)
    .bind(&req.photo_url)
    .bind(Utc::now().to_rfc3339())
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // Get updated item and transaction
    let item = get_item_by_id(pool, &req.item_id).await?;
    let transaction = get_transaction_by_id(pool, &transaction_id).await?;
    
    Ok(Json(StockAddResponse {
        success: true,
        message: format!("Stok bertambah {} {}", req.quantity, item.unit),
        item,
        transaction,
    }))
}

// ============================================
// REMOVE STOCK (Admin)
// POST /api/inventory/stock/remove
// ============================================
pub async fn remove_stock(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<RemoveStockRequest>,
) -> AppResult<Json<StockRemoveResponse>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    if req.quantity <= 0 {
        return Err(AppError::BadRequest("Jumlah harus lebih dari 0".to_string()));
    }
    
    // Get current item
    let current_item: (i32,) = sqlx::query_as(
        "SELECT current_stock FROM inventory_items WHERE id = ?1"
    )
    .bind(&req.item_id)
    .fetch_one(pool)
    .await
    .map_err(|_| AppError::NotFound("Item tidak ditemukan".to_string()))?;
    
    let old_quantity = current_item.0;
    let new_quantity = (old_quantity - req.quantity).max(0);
    
    if old_quantity < req.quantity {
        return Err(AppError::BadRequest(
            format!("Stok tidak cukup. Stok tersedia: {} {}", old_quantity, 
                    sqlx::query_scalar::<_, String>("SELECT unit FROM inventory_items WHERE id = ?1")
                    .bind(&req.item_id)
                    .fetch_one(pool)
                    .await.unwrap_or_default())
        ));
    }
    
    // Update inventory
    sqlx::query(
        "UPDATE inventory_items SET current_stock = ?1, updated_at = ?2 WHERE id = ?3"
    )
    .bind(new_quantity)
    .bind(Utc::now().to_rfc3339())
    .bind(&req.item_id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // Create transaction record
    let transaction_id = Uuid::new_v4().to_string();
    let branch_id = current_user.branch_id
        .ok_or(AppError::BadRequest("User tidak memiliki cabang".to_string()))?;
    
    sqlx::query(
        r#"
        INSERT INTO stock_transactions (
            id, item_id, branch_id, user_id, type, quantity,
            old_quantity, new_quantity, reason, reference_id, photo_url, created_at
        ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12)
        "#
    )
    .bind(&transaction_id)
    .bind(&req.item_id)
    .bind(&branch_id)
    .bind(&current_user.user_id)
    .bind("remove")
    .bind(req.quantity)
    .bind(old_quantity)
    .bind(new_quantity)
    .bind(&req.reason)
    .bind(&req.reference_id)
    .bind(&req.photo_url)
    .bind(Utc::now().to_rfc3339())
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // Get updated item and transaction
    let item = get_item_by_id(pool, &req.item_id).await?;
    let transaction = get_transaction_by_id(pool, &transaction_id).await?;
    
    Ok(Json(StockRemoveResponse {
        success: true,
        message: format!("Stok berkurang {} {}", req.quantity, item.unit),
        item,
        transaction,
    }))
}

// ============================================
// GET STOCK TRANSACTIONS
// GET /api/inventory/transactions
// ============================================
pub async fn get_stock_transactions(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<Vec<StockTransaction>>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    let mut query = String::from("SELECT * FROM stock_transactions WHERE 1=1");
    
    // Filter by branch
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            query.push_str(" AND branch_id = ?");
        }
    }
    
    // Filter by type
    if let Some(tx_type) = params.get("type") {
        query.push_str(" AND type = ?");
    }
    
    // Filter by date range
    if let Some(start_date) = params.get("start_date") {
        query.push_str(" AND created_at >= ?");
    }
    if let Some(end_date) = params.get("end_date") {
        query.push_str(" AND created_at <= ?");
    }
    
    query.push_str(" ORDER BY created_at DESC LIMIT 100");
    
    let mut q = sqlx::query_as::<_, StockTransaction>(&query);
    
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            q = q.bind(branch_id);
        }
    }
    
    if let Some(tx_type) = params.get("type") {
        q = q.bind(tx_type);
    }
    
    if let Some(start_date) = params.get("start_date") {
        q = q.bind(start_date);
    }
    if let Some(end_date) = params.get("end_date") {
        q = q.bind(end_date);
    }
    
    let transactions: Vec<StockTransaction> = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(transactions))
}

// ============================================
// GET INVENTORY ALERTS
// GET /api/inventory/alerts
// ============================================
pub async fn get_inventory_alerts(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<Vec<InventoryAlert>>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    let mut query = String::from("SELECT * FROM inventory_alerts WHERE 1=1");
    
    // Filter by branch
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            query.push_str(" AND branch_id = ?");
        }
    }
    
    // Filter by resolved status (default: show only unresolved)
    let show_resolved = params.get("show_resolved").map(|v| v == "true").unwrap_or(false);
    if !show_resolved {
        query.push_str(" AND is_resolved = 0");
    }
    
    // Filter by severity
    if let Some(severity) = params.get("severity") {
        query.push_str(" AND severity = ?");
    }
    
    query.push_str(" ORDER BY severity DESC, created_at DESC");
    
    let mut q = sqlx::query_as::<_, InventoryAlert>(&query);
    
    if current_user.role == UserRole::Admin {
        if let Some(branch_id) = &current_user.branch_id {
            q = q.bind(branch_id);
        }
    }
    
    if let Some(severity) = params.get("severity") {
        q = q.bind(severity);
    }
    
    let alerts: Vec<InventoryAlert> = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(alerts))
}

// ============================================
// GET INVENTORY STATS
// GET /api/inventory/stats
// ============================================
pub async fn get_inventory_stats(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<InventoryStats>> {
    let pool = &state.pool;
    
    // Only admin can access
    if current_user.role != UserRole::Admin && current_user.role != UserRole::Owner {
        return Err(AppError::Forbidden);
    }
    
    let branch_filter = if current_user.role == UserRole::Admin {
        current_user.branch_id.clone()
    } else {
        None
    };
    
    let total_items: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM inventory_items WHERE is_active = 1 AND (?1 IS NULL OR branch_id = ?1)"
    )
    .bind(&branch_filter)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let total_stock_value: Option<f64> = sqlx::query_scalar(
        "SELECT SUM(current_stock * COALESCE(price_per_unit, 0)) FROM inventory_items WHERE is_active = 1 AND (?1 IS NULL OR branch_id = ?1)"
    )
    .bind(&branch_filter)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let low_stock_items: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM inventory_items WHERE current_stock <= minimum_stock AND is_active = 1 AND (?1 IS NULL OR branch_id = ?1)"
    )
    .bind(&branch_filter)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let out_of_stock_items: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM inventory_items WHERE current_stock = 0 AND is_active = 1 AND (?1 IS NULL OR branch_id = ?1)"
    )
    .bind(&branch_filter)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let alerts_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM inventory_alerts WHERE is_resolved = 0 AND (?1 IS NULL OR branch_id = ?1)"
    )
    .bind(&branch_filter)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(InventoryStats {
        total_items,
        total_stock_value: total_stock_value.unwrap_or(0.0),
        low_stock_items,
        out_of_stock_items,
        alerts_count,
    }))
}

// ============================================
// HELPER FUNCTIONS
// ============================================

async fn get_item_by_id(pool: &Pool<Sqlite>, id: &str) -> AppResult<InventoryItem> {
    sqlx::query_as("SELECT * FROM inventory_items WHERE id = ?1")
        .bind(id)
        .fetch_one(pool)
        .await
        .map_err(|_| AppError::NotFound("Item tidak ditemukan".to_string()))
}

async fn get_transaction_by_id(pool: &Pool<Sqlite>, id: &str) -> AppResult<StockTransaction> {
    sqlx::query_as("SELECT * FROM stock_transactions WHERE id = ?1")
        .bind(id)
        .fetch_one(pool)
        .await
        .map_err(|_| AppError::NotFound("Transaction tidak ditemukan".to_string()))
}
