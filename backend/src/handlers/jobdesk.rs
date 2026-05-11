use axum::{
    body::Bytes,
    extract::{Path, State, Multipart, Query},
    http::StatusCode,
    response::{Json, IntoResponse},
    Extension,
};
use chrono::{NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{Pool, Sqlite};
use std::fs;
use std::path::Path as StdPath;
use std::sync::Arc;
use uuid::Uuid;

use crate::{
    AppState,
    error::AppError,
    middleware::{CurrentUser, UserRole},
};

// ===========================================
// REQUEST/RESPONSE MODELS
// ===========================================

#[derive(Debug, Deserialize)]
pub struct SubmitJobdeskRequest {
    pub notes: Option<String>,
    pub has_attachments: Option<bool>,
    pub proof_ids: Option<Vec<String>>, // IDs dari jobdesk_proofs yang sudah diupload
}

#[derive(Debug, Deserialize)]
pub struct ReviewJobdeskRequest {
    pub action: String, // "approve" atau "reject"
    pub review_notes: Option<String>,
    pub rejection_reason: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct CreateJobdeskRequest {
    pub user_id: String,
    pub template_id: Option<String>,
    pub title: String,
    pub description: Option<String>,
    pub assigned_date: NaiveDate,
    pub due_date: Option<NaiveDate>,
    pub priority: Option<String>, // low, normal, high, urgent
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct JobdeskAssignment {
    pub id: String,
    pub template_id: Option<String>,
    pub template_title: Option<String>,
    pub user_id: String,
    pub employee_name: String,
    pub division_name: String,
    pub branch_id: String,
    pub branch_name: String,
    pub title: String,
    pub description: Option<String>,
    pub assigned_date: NaiveDate,
    pub due_date: Option<NaiveDate>,
    pub priority: String,
    pub status: String,
    pub submitted_at: Option<String>,
    pub submitted_notes: Option<String>,
    pub has_attachments: i64,
    pub reviewed_by: Option<String>,
    pub reviewer_name: Option<String>,
    pub reviewed_at: Option<String>,
    pub review_notes: Option<String>,
    pub rejection_reason: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct JobdeskProof {
    pub id: String,
    pub assignment_id: Option<String>,
    pub file_name: String,
    pub original_name: String,
    pub file_path: String,
    pub file_type: String,
    pub file_size: i64,
    pub is_converted: i64,
    pub created_at: String,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct JobdeskStats {
    pub total: i64,
    pub assigned: i64,
    pub submitted: i64,
    pub approved: i64,
    pub rejected: i64,
}

// ===========================================
// KARYAWAN ENDPOINTS
// ===========================================

/// Get my jobdesk assignments (karyawan)
pub async fn get_my_assignments(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<JobdeskAssignment>>, AppError> {
    let pool = &state.pool;
    
    let assignments = sqlx::query_as::<_, JobdeskAssignment>(
        r#"
        SELECT 
            ja.id,
            ja.template_id,
            jt.title as template_title,
            ja.user_id,
            u.full_name as employee_name,
            d.name as division_name,
            ja.branch_id,
            b.name as branch_name,
            ja.title,
            ja.description,
            ja.assigned_date,
            ja.due_date,
            ja.priority,
            ja.status,
            ja.submitted_at,
            ja.submitted_notes,
            ja.has_attachments,
            ja.reviewed_by,
            ru.full_name as reviewer_name,
            ja.reviewed_at,
            ja.review_notes,
            ja.rejection_reason
        FROM jobdesk_assignments ja
        JOIN users u ON ja.user_id = u.id
        JOIN divisions d ON u.division_id = d.id
        JOIN branches b ON ja.branch_id = b.id
        LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
        LEFT JOIN users ru ON ja.reviewed_by = ru.id
        WHERE ja.user_id = ?1
        ORDER BY ja.assigned_date DESC, ja.priority DESC
        "#
    )
    .bind(&current_user.user_id)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(assignments))
}

/// Submit jobdesk assignment (karyawan)
pub async fn submit_jobdesk(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
    Json(body): Json<SubmitJobdeskRequest>,
) -> Result<StatusCode, AppError> {
    let pool = &state.pool;
    
    // Verify ownership
    let assignment: Option<(String, String)> = sqlx::query_as(
        "SELECT id, status FROM jobdesk_assignments WHERE id = ?1 AND user_id = ?2"
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    if assignment.is_none() {
        return Err(AppError::NotFoundSimple);
    }
    
    let (_, status) = assignment.unwrap();
    if status != "assigned" {
        return Err(AppError::BadRequest(format!("Cannot submit jobdesk with status: {}", status)));
    }
    
    let now = Utc::now();
    let has_attachments = body.has_attachments.unwrap_or(false);
    
    // Update assignment status
    sqlx::query(
        r#"
        UPDATE jobdesk_assignments 
        SET status = 'submitted',
            submitted_at = ?1,
            submitted_notes = ?2,
            has_attachments = ?3
        WHERE id = ?4
        "#
    )
    .bind(now)
    .bind(body.notes)
    .bind(has_attachments)
    .bind(&id)
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    // Link proofs to assignment if provided
    if let Some(proof_ids) = body.proof_ids {
        for proof_id in proof_ids {
            sqlx::query(
                "UPDATE jobdesk_proofs SET assignment_id = ?1 WHERE id = ?2"
            )
            .bind(&id)
            .bind(proof_id)
            .execute(pool)
            .await
            .map_err(|e| AppError::DatabaseError(e.to_string()))?;
        }
    }
    
    Ok(StatusCode::OK)
}

/// Get jobdesk detail with proofs
pub async fn get_jobdesk_detail(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
) -> Result<Json<(JobdeskAssignment, Vec<JobdeskProof>)>, AppError> {
    let pool = &state.pool;
    
    let assignment = sqlx::query_as::<_, JobdeskAssignment>(
        r#"
        SELECT 
            ja.id,
            ja.template_id,
            jt.title as template_title,
            ja.user_id,
            u.full_name as employee_name,
            d.name as division_name,
            ja.branch_id,
            b.name as branch_name,
            ja.title,
            ja.description,
            ja.assigned_date,
            ja.due_date,
            ja.priority,
            ja.status,
            ja.submitted_at,
            ja.submitted_notes,
            ja.has_attachments,
            ja.reviewed_by,
            ru.full_name as reviewer_name,
            ja.reviewed_at,
            ja.review_notes,
            ja.rejection_reason
        FROM jobdesk_assignments ja
        JOIN users u ON ja.user_id = u.id
        JOIN divisions d ON u.division_id = d.id
        JOIN branches b ON ja.branch_id = b.id
        LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
        LEFT JOIN users ru ON ja.reviewed_by = ru.id
        WHERE ja.id = ?1 AND (ja.user_id = ?2 OR ja.assigner_id = ?2 OR ?3 = 'Owner')
        "#
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(current_user.role.as_str())
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    if assignment.is_none() {
        return Err(AppError::NotFoundSimple);
    }
    
    let assignment = assignment.unwrap();
    
    let proofs = sqlx::query_as::<_, JobdeskProof>(
        r#"
        SELECT id, assignment_id, file_name, original_name, file_path, 
               file_type, file_size, is_converted, created_at
        FROM jobdesk_proofs 
        WHERE assignment_id = ?1
        ORDER BY created_at ASC
        "#
    )
    .bind(&id)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json((assignment, proofs)))
}

// ===========================================
// PIC/KEPALA CABANG ENDPOINTS
// ===========================================

/// Get pending jobdesk for review (Pak Kevin)
pub async fn get_pending_review(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(branch_id): Query<Option<String>>,
) -> Result<Json<Vec<JobdeskAssignment>>, AppError> {
    let pool = &state.pool;
    
    // Hanya Owner, KepalaCabang, PIC Pelaporan, atau Admin yang bisa review
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    let branch_filter = branch_id.unwrap_or_else(|| {
        if current_user.role == UserRole::KepalaCabang {
            current_user.branch_id.clone().unwrap_or_default()
        } else {
            String::new()
        }
    });
    
    let assignments = if current_user.role == UserRole::Owner {
        sqlx::query_as::<_, JobdeskAssignment>(
            r#"
            SELECT 
                ja.id,
                ja.template_id,
                jt.title as template_title,
                ja.user_id,
                u.full_name as employee_name,
                d.name as division_name,
                ja.branch_id,
                b.name as branch_name,
                ja.title,
                ja.description,
                ja.assigned_date,
                ja.due_date,
                ja.priority,
                ja.status,
                ja.submitted_at,
                ja.submitted_notes,
                ja.has_attachments,
                ja.reviewed_by,
                ru.full_name as reviewer_name,
                ja.reviewed_at,
                ja.review_notes,
                ja.rejection_reason
            FROM jobdesk_assignments ja
            JOIN users u ON ja.user_id = u.id
            JOIN divisions d ON u.division_id = d.id
            JOIN branches b ON ja.branch_id = b.id
            LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
            LEFT JOIN users ru ON ja.reviewed_by = ru.id
            WHERE ja.status = 'submitted'
            ORDER BY ja.submitted_at ASC
            "#
        )
        .fetch_all(pool)
        .await
    } else {
        sqlx::query_as::<_, JobdeskAssignment>(
            r#"
            SELECT 
                ja.id,
                ja.template_id,
                jt.title as template_title,
                ja.user_id,
                u.full_name as employee_name,
                d.name as division_name,
                ja.branch_id,
                b.name as branch_name,
                ja.title,
                ja.description,
                ja.assigned_date,
                ja.due_date,
                ja.priority,
                ja.status,
                ja.submitted_at,
                ja.submitted_notes,
                ja.has_attachments,
                ja.reviewed_by,
                ru.full_name as reviewer_name,
                ja.reviewed_at,
                ja.review_notes,
                ja.rejection_reason
            FROM jobdesk_assignments ja
            JOIN users u ON ja.user_id = u.id
            JOIN divisions d ON u.division_id = d.id
            JOIN branches b ON ja.branch_id = b.id
            LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
            LEFT JOIN users ru ON ja.reviewed_by = ru.id
            WHERE ja.status = 'submitted' AND ja.branch_id = ?1
            ORDER BY ja.submitted_at ASC
            "#
        )
        .bind(branch_filter)
        .fetch_all(pool)
        .await
    };
    
    let assignments = assignments.map_err(|e| AppError::DatabaseError(e.to_string()))?;
    Ok(Json(assignments))
}

/// Review jobdesk (approve/reject) - Pak Kevin
pub async fn review_jobdesk(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
    Json(body): Json<ReviewJobdeskRequest>,
) -> Result<StatusCode, AppError> {
    let pool = &state.pool;
    
    // Hanya Owner, KepalaCabang, PIC Pelaporan, atau Admin yang bisa review
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    let new_status = match body.action.as_str() {
        "approve" => "approved",
        "reject" => "rejected",
        _ => return Err(AppError::BadRequest("Invalid action. Use 'approve' or 'reject'".to_string())),
    };
    
    let now = Utc::now();
    
    sqlx::query(
        r#"
        UPDATE jobdesk_assignments 
        SET status = ?1,
            reviewed_by = ?2,
            reviewed_at = ?3,
            review_notes = ?4,
            rejection_reason = ?5
        WHERE id = ?6 AND status = 'submitted'
        "#
    )
    .bind(new_status)
    .bind(&current_user.user_id)
    .bind(now)
    .bind(body.review_notes)
    .bind(body.rejection_reason)
    .bind(&id)
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(StatusCode::OK)
}

/// Create new jobdesk assignment (Pak Kevin assign ke karyawan)
pub async fn create_jobdesk(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(body): Json<CreateJobdeskRequest>,
) -> Result<Json<JobdeskAssignment>, AppError> {
    let pool = &state.pool;
    
    // Hanya Owner, KepalaCabang, PIC Pelaporan, atau Admin yang bisa assign
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    let id = format!("jd-{}", Uuid::new_v4().to_string().split('-').next().unwrap());
    let now = Utc::now();
    
    // Get karyawan's branch_id
    let branch_id: String = sqlx::query_scalar(
        "SELECT branch_id FROM users WHERE id = ?1"
    )
    .bind(&body.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    sqlx::query(
        r#"
        INSERT INTO jobdesk_assignments 
        (id, template_id, user_id, assigner_id, branch_id, title, description, 
         assigned_date, due_date, priority, status, has_attachments, created_at)
        VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, 'assigned', 0, ?11)
        "#
    )
    .bind(&id)
    .bind(body.template_id)
    .bind(&body.user_id)
    .bind(&current_user.user_id)
    .bind(branch_id)
    .bind(&body.title)
    .bind(body.description)
    .bind(body.assigned_date)
    .bind(body.due_date)
    .bind(body.priority.unwrap_or_else(|| "normal".to_string()))
    .bind(now)
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    // Return created assignment
    let assignment = sqlx::query_as::<_, JobdeskAssignment>(
        r#"
        SELECT 
            ja.id,
            ja.template_id,
            jt.title as template_title,
            ja.user_id,
            u.full_name as employee_name,
            d.name as division_name,
            ja.branch_id,
            b.name as branch_name,
            ja.title,
            ja.description,
            ja.assigned_date,
            ja.due_date,
            ja.priority,
            ja.status,
            ja.submitted_at,
            ja.submitted_notes,
            ja.has_attachments,
            ja.reviewed_by,
            ru.full_name as reviewer_name,
            ja.reviewed_at,
            ja.review_notes,
            ja.rejection_reason
        FROM jobdesk_assignments ja
        JOIN users u ON ja.user_id = u.id
        JOIN divisions d ON u.division_id = d.id
        JOIN branches b ON ja.branch_id = b.id
        LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
        LEFT JOIN users ru ON ja.reviewed_by = ru.id
        WHERE ja.id = ?1
        "#
    )
    .bind(&id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(assignment))
}

/// Get jobdesk stats untuk dashboard
pub async fn get_jobdesk_stats(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(branch_id): Query<Option<String>>,
) -> Result<Json<JobdeskStats>, AppError> {
    let pool = &state.pool;
    
    let branch_filter = if current_user.role == UserRole::Owner {
        branch_id.unwrap_or_default()
    } else {
        current_user.branch_id.clone().unwrap_or_default()
    };
    
    let stats = if current_user.role == UserRole::Owner && branch_filter.is_empty() {
        sqlx::query_as::<_, JobdeskStats>(
            r#"
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN status = 'assigned' THEN 1 ELSE 0 END) as assigned,
                SUM(CASE WHEN status = 'submitted' THEN 1 ELSE 0 END) as submitted,
                SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved,
                SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected
            FROM jobdesk_assignments
            "#
        )
        .fetch_one(pool)
        .await
    } else {
        sqlx::query_as::<_, JobdeskStats>(
            r#"
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN status = 'assigned' THEN 1 ELSE 0 END) as assigned,
                SUM(CASE WHEN status = 'submitted' THEN 1 ELSE 0 END) as submitted,
                SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved,
                SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected
            FROM jobdesk_assignments
            WHERE branch_id = ?1
            "#
        )
        .bind(branch_filter)
        .fetch_one(pool)
        .await
    };
    
    let stats = stats.map_err(|e| AppError::DatabaseError(e.to_string()))?;
    Ok(Json(stats))
}

/// Get all jobdesk assignments (untuk Owner/PIC monitoring)
pub async fn get_all_assignments(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(status): Query<Option<String>>,
    Query(branch_id): Query<Option<String>>,
    Query(user_id): Query<Option<String>>,
) -> Result<Json<Vec<JobdeskAssignment>>, AppError> {
    let pool = &state.pool;
    
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    let mut query = String::from(
        r#"
        SELECT 
            ja.id,
            ja.template_id,
            jt.title as template_title,
            ja.user_id,
            u.full_name as employee_name,
            d.name as division_name,
            ja.branch_id,
            b.name as branch_name,
            ja.title,
            ja.description,
            ja.assigned_date,
            ja.due_date,
            ja.priority,
            ja.status,
            ja.submitted_at,
            ja.submitted_notes,
            ja.has_attachments,
            ja.reviewed_by,
            ru.full_name as reviewer_name,
            ja.reviewed_at,
            ja.review_notes,
            ja.rejection_reason
        FROM jobdesk_assignments ja
        JOIN users u ON ja.user_id = u.id
        JOIN divisions d ON u.division_id = d.id
        JOIN branches b ON ja.branch_id = b.id
        LEFT JOIN jobdesk_templates jt ON ja.template_id = jt.id
        LEFT JOIN users ru ON ja.reviewed_by = ru.id
        WHERE 1=1
        "#
    );
    
    if current_user.role == UserRole::KepalaCabang {
        if current_user.branch_id.is_some() {
            query.push_str(" AND ja.branch_id = ?");
        }
    } else if branch_id.is_some() {
        query.push_str(" AND ja.branch_id = ?");
    }
    
    if status.is_some() {
        query.push_str(" AND ja.status = ?");
    }
    
    if user_id.is_some() {
        query.push_str(" AND ja.user_id = ?");
    }
    
    query.push_str(" ORDER BY ja.assigned_date DESC, ja.priority DESC");
    
    let mut q = sqlx::query_as::<_, JobdeskAssignment>(&query);
    
    if current_user.role == UserRole::KepalaCabang {
        if let Some(bid) = &current_user.branch_id {
            q = q.bind(bid);
        }
    } else if let Some(bid) = &branch_id {
        q = q.bind(bid);
    }
    
    if let Some(s) = &status {
        q = q.bind(s);
    }
    
    if let Some(uid) = &user_id {
        q = q.bind(uid);
    }
    
    let assignments = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(assignments))
}

// ===========================================
// TEMPLATES ENDPOINTS
// ===========================================

#[derive(Debug, Serialize, sqlx::FromRow, Clone)]
pub struct JobdeskTemplate {
    pub id: String,
    pub division_id: String,
    pub division_name: String,
    pub title: String,
    pub description: Option<String>,
    pub instructions: Option<String>,
    pub allow_photo: i64,
    pub allow_video: i64,
    pub allow_no_attachment: i64,
}

/// Get jobdesk templates untuk karyawan (berdasarkan divisi mereka)
pub async fn get_my_templates(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<JobdeskTemplate>>, AppError> {
    let pool = &state.pool;
    
    let templates = sqlx::query_as::<_, JobdeskTemplate>(
        r#"
        SELECT 
            jt.id,
            jt.division_id,
            d.name as division_name,
            jt.title,
            jt.description,
            jt.instructions,
            jt.allow_photo,
            jt.allow_video,
            jt.allow_no_attachment
        FROM jobdesk_templates jt
        JOIN divisions d ON jt.division_id = d.id
        JOIN users u ON u.division_id = d.id
        WHERE u.id = ?1 AND jt.is_active = 1
        ORDER BY jt.title ASC
        "#
    )
    .bind(&current_user.user_id)
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(templates))
}

/// Get all templates (untuk Owner/Admin assign jobdesk)
pub async fn get_all_templates(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> Result<Json<Vec<JobdeskTemplate>>, AppError> {
    let pool = &state.pool;
    
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    let templates = sqlx::query_as::<_, JobdeskTemplate>(
        r#"
        SELECT 
            jt.id,
            jt.division_id,
            d.name as division_name,
            jt.title,
            jt.description,
            jt.instructions,
            jt.allow_photo,
            jt.allow_video,
            jt.allow_no_attachment
        FROM jobdesk_templates jt
        JOIN divisions d ON jt.division_id = d.id
        WHERE jt.is_active = 1
        ORDER BY d.name, jt.title ASC
        "#
    )
    .fetch_all(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(templates))
}

// ===========================================
// FILE UPLOAD & PROOF ENDPOINTS
// ===========================================

// Duplicate imports removed

#[derive(Debug, Serialize)]
pub struct UploadResponse {
    pub proof_id: String,
    pub file_name: String,
    pub original_name: String,
    pub file_type: String,
    pub file_size: i64,
    pub message: String,
}

/// Upload proof file (gambar/video) untuk jobdesk
pub async fn upload_proof(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    mut multipart: Multipart,
) -> Result<Json<UploadResponse>, AppError> {
    let pool = &state.pool;
    
    // Create uploads directory if not exists
    let upload_dir = StdPath::new("uploads/jobdesk");
    fs::create_dir_all(upload_dir).map_err(|e| AppError::InternalError(format!("Failed to create upload dir: {}", e)))?;
    
    let proof_id = format!("proof-{}", Uuid::new_v4().to_string().split('-').next().unwrap());
    let now = Utc::now();
    
    let mut original_name = String::new();
    let mut file_type = String::new();
    let mut file_size: i64 = 0;
    let mut file_data = Vec::new();
    
    // Parse multipart form
    while let Some(field) = multipart.next_field().await.map_err(|e| AppError::BadRequest(format!("Upload error: {}", e)))? {
        let name = field.name().unwrap_or("").to_string();
        
        if name == "file" {
            original_name = field.file_name().unwrap_or("unknown").to_string();
            let content_type = field.content_type().unwrap_or("application/octet-stream").to_string();
            
            // Determine file type
            file_type = if content_type.starts_with("image/") {
                content_type.clone()
            } else if content_type.starts_with("video/") {
                content_type.clone()
            } else {
                return Err(AppError::BadRequest("Only image and video files are allowed".to_string()));
            };
            
            // Read file data
            let data = field.bytes().await.map_err(|e| AppError::BadRequest(format!("Failed to read file: {}", e)))?;
            file_size = data.len() as i64;
            file_data = data.to_vec();
            
            // Check file size (max 50MB)
            if file_size > 50 * 1024 * 1024 {
                return Err(AppError::BadRequest("File size exceeds 50MB limit".to_string()));
            }
        }
    }
    
    if file_data.is_empty() {
        return Err(AppError::BadRequest("No file uploaded".to_string()));
    }
    
    // Generate safe filename
    let extension = StdPath::new(&original_name)
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("bin");
    let file_name = format!("{}.{}", proof_id, extension);
    let file_path = upload_dir.join(&file_name);
    
    // Save file
    fs::write(&file_path, &file_data).map_err(|e| AppError::InternalError(format!("Failed to save file: {}", e)))?;
    
    // Save to database
    sqlx::query(
        r#"
        INSERT INTO jobdesk_proofs (id, assignment_id, file_name, original_name, file_path, file_type, file_size, is_converted, created_at)
        VALUES (?1, NULL, ?2, ?3, ?4, ?5, ?6, 0, ?7)
        "#
    )
    .bind(&proof_id)
    .bind(&file_name)
    .bind(&original_name)
    .bind(file_path.to_str().unwrap_or(""))
    .bind(&file_type)
    .bind(file_size)
    .bind(now)
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(UploadResponse {
        proof_id,
        file_name,
        original_name: original_name.clone(),
        file_type,
        file_size,
        message: "File uploaded successfully. Link to assignment with submit endpoint.".to_string(),
    }))
}

/// Get proof file (download)
pub async fn get_proof(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
) -> Result<impl IntoResponse, AppError> {
    let pool = &state.pool;
    
    // Get proof info
    let proof: Option<JobdeskProof> = sqlx::query_as::<_, JobdeskProof>(
        "SELECT id, assignment_id, file_name, original_name, file_path, file_type, file_size, is_converted, created_at FROM jobdesk_proofs WHERE id = ?1"
    )
    .bind(&id)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    if proof.is_none() {
        return Err(AppError::NotFoundSimple);
    }
    
    let proof = proof.unwrap();
    
    // Check permission (owner, PIC, or assigned karyawan)
    if current_user.role != UserRole::Owner {
        if let Some(assignment_id) = &proof.assignment_id {
            let has_access: Option<(String, String)> = sqlx::query_as(
                "SELECT user_id, assigner_id FROM jobdesk_assignments WHERE id = ?1"
            )
            .bind(assignment_id)
            .fetch_optional(pool)
            .await
            .map_err(|e| AppError::DatabaseError(e.to_string()))?;
            
            if let Some((user_id, assigner_id)) = has_access {
                if current_user.user_id != user_id && current_user.user_id != assigner_id {
                    return Err(AppError::Forbidden);
                }
            }
        }
    }
    
    // Read file
    let file_data = fs::read(&proof.file_path)
        .map_err(|_| AppError::NotFoundSimple)?;
    
    let content_type = match proof.file_type.as_str() {
        t if t.starts_with("image/") => t.to_string(),
        t if t.starts_with("video/") => t.to_string(),
        _ => "application/octet-stream".to_string(),
    };
    
    Ok((
        StatusCode::OK,
        [
            ("Content-Type", content_type),
            ("Content-Disposition", format!("inline; filename=\"{}\"", proof.original_name)),
        ],
        file_data,
    ))
}

/// Convert image to webp format (hemat storage)
#[axum::debug_handler]
pub async fn convert_to_webp(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Path(id): Path<String>,
) -> Result<Json<UploadResponse>, AppError> {
    let pool = &state.pool;
    
    // Only Owner/Admin/PIC can convert
    if !matches!(current_user.role, UserRole::Owner | UserRole::KepalaCabang | UserRole::PicPelaporan | UserRole::Admin) {
        return Err(AppError::Forbidden);
    }
    
    // Get original proof
    let proof: Option<JobdeskProof> = sqlx::query_as::<_, JobdeskProof>(
        "SELECT id, assignment_id, file_name, original_name, file_path, file_type, file_size, is_converted, created_at FROM jobdesk_proofs WHERE id = ?1"
    )
    .bind(&id)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    if proof.is_none() {
        return Err(AppError::NotFoundSimple);
    }
    
    let proof = proof.unwrap();
    
    // Only convert images
    if !proof.file_type.starts_with("image/") {
        return Err(AppError::BadRequest("Only images can be converted to webp".to_string()));
    }
    
    // Already converted
    if proof.is_converted == 1 {
        return Err(AppError::BadRequest("Already converted to webp".to_string()));
    }
    
    // Read original image
    let img_data = fs::read(&proof.file_path)
        .map_err(|e| AppError::InternalError(format!("Failed to read image: {}", e)))?;
    
    // Decode image
    let img = image::load_from_memory(&img_data)
        .map_err(|e| AppError::InternalError(format!("Failed to decode image: {}", e)))?;
    
    // Convert to webp
    let webp_id = format!("{}-webp", proof.id);
    let webp_name = format!("{}.webp", webp_id);
    let upload_dir = StdPath::new("uploads/jobdesk");
    let webp_path = upload_dir.join(&webp_name);
    
    // Encode to webp in a block to ensure non-Send WebPMemory is dropped before await
    let webp_len = {
        let webp_data = img.to_rgba8();
        let encoder = webp::Encoder::from_rgba(&webp_data, img.width(), img.height());
        let webp_bytes = encoder.encode_lossless();
        let len = webp_bytes.len();
        fs::write(&webp_path, &*webp_bytes)
            .map_err(|e| AppError::InternalError(format!("Failed to save webp: {}", e)))?;
        len as i64
    };
    
    let now = Utc::now();
    
    // Save new webp proof to database
    sqlx::query(
        r#"
        INSERT INTO jobdesk_proofs (id, assignment_id, file_name, original_name, file_path, file_type, file_size, is_converted, original_file_id, created_at)
        VALUES (?1, ?2, ?3, ?4, ?5, 'image/webp', ?6, 1, ?7, ?8)
        "#
    )
    .bind(&webp_id)
    .bind(&proof.assignment_id)
    .bind(&webp_name)
    .bind(format!("{}.webp", proof.original_name))
    .bind(webp_path.to_str().unwrap_or(""))
    .bind(webp_len)
    .bind(&proof.id)
    .bind(now)
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;
    
    Ok(Json(UploadResponse {
        proof_id: webp_id,
        file_name: webp_name,
        original_name: format!("{}.webp", proof.original_name),
        file_type: "image/webp".to_string(),
        file_size: webp_len,
        message: format!("Converted to webp. Original: {} bytes, Webp: {} bytes", proof.file_size, webp_len),
    }))
}
