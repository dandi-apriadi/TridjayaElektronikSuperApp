use axum::{
    extract::{Query, State},
    Json,
    Extension,
};
use chrono::{DateTime, Datelike, Local, NaiveDate, Timelike, Utc};
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
pub struct CheckInRequest {
    pub latitude: f64,
    pub longitude: f64,
    pub photo_url: Option<String>,
    pub notes: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct CheckOutRequest {
    pub latitude: f64,
    pub longitude: f64,
    pub notes: Option<String>,
}

#[derive(Debug, Serialize, sqlx::FromRow)]
pub struct Attendance {
    pub id: String,
    pub user_id: String,
    pub date: String, // DATE format YYYY-MM-DD
    pub clock_in: Option<String>,
    pub clock_out: Option<String>,
    pub status: String, // present, absent, late, on_leave
    pub location_lat: Option<f64>,
    pub location_lng: Option<f64>,
    pub photo_url: Option<String>,
    pub notes: Option<String>,
    pub created_at: String,
}

#[derive(Debug, Serialize)]
pub struct AttendanceDetail {
    pub id: String,
    pub user_id: String,
    pub username: Option<String>,
    pub full_name: Option<String>,
    pub date: String,
    pub clock_in: Option<String>,
    pub clock_out: Option<String>,
    pub status: String,
    pub location_lat: Option<f64>,
    pub location_lng: Option<f64>,
    pub photo_url: Option<String>,
    pub notes: Option<String>,
    pub working_hours: Option<String>, // Format: "8.5 jam"
    pub is_late: bool,
    pub created_at: String,
}

#[derive(Debug, Serialize)]
pub struct AttendanceSummary {
    pub total_present: i64,
    pub total_absent: i64,
    pub total_late: i64,
    pub total_leave: i64,
    pub attendance_rate: f64, // Persentase
    pub this_month_present: i64,
    pub this_week_present: i64,
}

#[derive(Debug, Serialize)]
pub struct CheckInResponse {
    pub success: bool,
    pub message: String,
    pub attendance: AttendanceDetail,
}

#[derive(Debug, Serialize)]
pub struct CheckOutResponse {
    pub success: bool,
    pub message: String,
    pub working_hours: String,
    pub attendance: AttendanceDetail,
}

// ============================================
// CHECK IN
// POST /api/attendance/check-in
// ============================================
pub async fn check_in(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CheckInRequest>,
) -> AppResult<Json<CheckInResponse>> {
    let pool = &state.pool;
    let today = Local::now().format("%Y-%m-%d").to_string();
    
    // Cek apakah sudah check-in hari ini
    let existing: Option<(String,)> = sqlx::query_as(
        "SELECT id FROM attendance WHERE user_id = ?1 AND date = ?2"
    )
    .bind(&current_user.user_id)
    .bind(&today)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    if existing.is_some() {
        return Err(AppError::BadRequest(
            "Anda sudah melakukan check-in hari ini".to_string()
        ));
    }
    
    let id = Uuid::new_v4().to_string();
    let clock_in = Utc::now().to_rfc3339();
    let created_at = Utc::now().to_rfc3339();
    
    // Determine status (late if after 09:00)
    let hour = Utc::now().hour();
    let minute = Utc::now().minute();
    let status = if hour > 9 || (hour == 9 && minute > 0) {
        "late"
    } else {
        "present"
    };
    
    sqlx::query(
        r#"
        INSERT INTO attendance (
            id, user_id, date, clock_in, status,
            location_lat, location_lng, photo_url, notes, created_at
        ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10)
        "#
    )
    .bind(&id)
    .bind(&current_user.user_id)
    .bind(&today)
    .bind(&clock_in)
    .bind(status)
    .bind(req.latitude)
    .bind(req.longitude)
    .bind(&req.photo_url)
    .bind(&req.notes)
    .bind(&created_at)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let attendance = get_attendance_by_id(pool, &id, &current_user.user_id).await?;
    
    Ok(Json(CheckInResponse {
        success: true,
        message: "Check-in berhasil".to_string(),
        attendance,
    }))
}

// ============================================
// CHECK OUT
// POST /api/attendance/check-out
// ============================================
pub async fn check_out(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Json(req): Json<CheckOutRequest>,
) -> AppResult<Json<CheckOutResponse>> {
    let pool = &state.pool;
    let today = Local::now().format("%Y-%m-%d").to_string();
    
    // Cek apakah sudah check-in hari ini
    let attendance_record: (String, Option<String>, Option<String>) = sqlx::query_as(
        "SELECT id, clock_in, clock_out FROM attendance WHERE user_id = ?1 AND date = ?2"
    )
    .bind(&current_user.user_id)
    .bind(&today)
    .fetch_optional(pool)
    .await
    .map_err(|e| AppError::Database(e))?
    .ok_or(AppError::BadRequest(
        "Anda belum melakukan check-in hari ini".to_string()
    ))?;
    
    if attendance_record.2.is_some() {
        return Err(AppError::BadRequest(
            "Anda sudah melakukan check-out hari ini".to_string()
        ));
    }
    
    let clock_out = Utc::now().to_rfc3339();
    let id = &attendance_record.0;
    
    // Calculate working hours
    let clock_in_str = attendance_record.1.ok_or(AppError::BadRequest(
        "Clock-in tidak ditemukan".to_string()
    ))?;
    
    let clock_in_dt = DateTime::parse_from_rfc3339(&clock_in_str)
        .map_err(|_| AppError::BadRequest("Format waktu tidak valid".to_string()))?;
    let clock_out_dt = DateTime::parse_from_rfc3339(&clock_out)
        .map_err(|_| AppError::BadRequest("Format waktu tidak valid".to_string()))?;
    
    let duration = clock_out_dt.signed_duration_since(clock_in_dt);
    let hours = duration.num_minutes() as f64 / 60.0;
    let working_hours_str = format!("{:.1} jam", hours);
    
    sqlx::query(
        "UPDATE attendance SET clock_out = ?1 WHERE id = ?2"
    )
    .bind(&clock_out)
    .bind(id)
    .execute(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let attendance = get_attendance_by_id(pool, id, &current_user.user_id).await?;
    
    Ok(Json(CheckOutResponse {
        success: true,
        message: "Check-out berhasil".to_string(),
        working_hours: working_hours_str,
        attendance,
    }))
}

// ============================================
// GET MY ATTENDANCE HISTORY
// GET /api/attendance/my-history
// ============================================
pub async fn get_my_attendance_history(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
    Query(params): Query<std::collections::HashMap<String, String>>,
) -> AppResult<Json<Vec<AttendanceDetail>>> {
    let pool = &state.pool;
    
    let mut query = String::from(
        r#"
        SELECT 
            a.id, a.user_id, u.username, u.full_name,
            a.date, a.clock_in, a.clock_out, a.status,
            a.location_lat, a.location_lng, a.photo_url,
            a.notes, a.created_at
        FROM attendance a
        JOIN users u ON u.id = a.user_id
        WHERE a.user_id = ?1
        "#
    );
    
    // Filter by status
    if let Some(status) = params.get("status") {
        query.push_str(" AND a.status = ?");
    }
    
    // Filter by start date
    if let Some(start_date) = params.get("start_date") {
        query.push_str(" AND a.date >= ?");
    }
    
    // Filter by end date
    if let Some(end_date) = params.get("end_date") {
        query.push_str(" AND a.date <= ?");
    }
    
    query.push_str(" ORDER BY a.date DESC LIMIT 100");
    
    let mut q = sqlx::query_as::<_, (String, String, Option<String>, Option<String>, String, Option<String>, Option<String>, String, Option<f64>, Option<f64>, Option<String>, Option<String>, String)>(&query);
    
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
    
    let records = q
        .fetch_all(pool)
        .await
        .map_err(|e| AppError::Database(e))?;
    
    let mut attendances = Vec::new();
    
    for record in records {
        let is_late = record.7 == "late"; // status
        
        let working_hours = if let (Some(clock_in), Some(clock_out)) = (&record.5, &record.6) {
            calculate_working_hours(clock_in, clock_out).ok()
        } else {
            None
        };
        
        attendances.push(AttendanceDetail {
            id: record.0,
            user_id: record.1,
            username: record.2,
            full_name: record.3,
            date: record.4,
            clock_in: record.5,
            clock_out: record.6,
            status: record.7,
            location_lat: record.8,
            location_lng: record.9,
            photo_url: record.10,
            notes: record.11,
            working_hours,
            is_late,
            created_at: record.12,
        });
    }
    
    Ok(Json(attendances))
}

// ============================================
// GET ATTENDANCE SUMMARY
// GET /api/attendance/summary
// ============================================
pub async fn get_attendance_summary(
    State(state): State<Arc<AppState>>,
    Extension(current_user): Extension<CurrentUser>,
) -> AppResult<Json<AttendanceSummary>> {
    let pool = &state.pool;
    
    let today = Local::now();
    let first_day_of_month = today
        .with_day(1)
        .ok_or(AppError::BadRequest("Invalid date".to_string()))?;
    
    let month_start = first_day_of_month.format("%Y-%m-%d").to_string();
    let today_str = today.format("%Y-%m-%d").to_string();
    let week_start = (today - chrono::Duration::days(7))
        .format("%Y-%m-%d")
        .to_string();
    
    // Total counts
    let total_present: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'present'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let total_absent: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'absent'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let total_late: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'late'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let total_leave: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'on_leave'"
    )
    .bind(&current_user.user_id)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    let total_records = total_present + total_absent + total_late + total_leave;
    let attendance_rate = if total_records > 0 {
        ((total_present + total_late) as f64 / total_records as f64) * 100.0
    } else {
        0.0
    };
    
    // This month
    let this_month_present: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'present' AND date >= ?2 AND date <= ?3"
    )
    .bind(&current_user.user_id)
    .bind(&month_start)
    .bind(&today_str)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    // This week
    let this_week_present: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM attendance WHERE user_id = ?1 AND status = 'present' AND date >= ?2 AND date <= ?3"
    )
    .bind(&current_user.user_id)
    .bind(&week_start)
    .bind(&today_str)
    .fetch_one(pool)
    .await
    .map_err(|e| AppError::Database(e))?;
    
    Ok(Json(AttendanceSummary {
        total_present,
        total_absent,
        total_late,
        total_leave,
        attendance_rate: (attendance_rate * 100.0).round() / 100.0,
        this_month_present,
        this_week_present,
    }))
}

// ============================================
// HELPER FUNCTIONS
// ============================================

async fn get_attendance_by_id(
    pool: &Pool<Sqlite>,
    id: &str,
    user_id: &str,
) -> AppResult<AttendanceDetail> {
    let record: (String, String, Option<String>, Option<String>, String, Option<String>, Option<String>, String, Option<f64>, Option<f64>, Option<String>, Option<String>, String) 
        = sqlx::query_as(
            r#"
            SELECT 
                a.id, a.user_id, u.username, u.full_name,
                a.date, a.clock_in, a.clock_out, a.status,
                a.location_lat, a.location_lng, a.photo_url,
                a.notes, a.created_at
            FROM attendance a
            JOIN users u ON u.id = a.user_id
            WHERE a.id = ?1 AND a.user_id = ?2
            "#
        )
        .bind(id)
        .bind(user_id)
        .fetch_one(pool)
        .await
        .map_err(|_| AppError::NotFound("Attendance record not found".to_string()))?;
    
    let is_late = record.7 == "late";
    
    let working_hours = if let (Some(clock_in), Some(clock_out)) = (&record.5, &record.6) {
        calculate_working_hours(clock_in, clock_out).ok()
    } else {
        None
    };
    
    Ok(AttendanceDetail {
        id: record.0,
        user_id: record.1,
        username: record.2,
        full_name: record.3,
        date: record.4,
        clock_in: record.5,
        clock_out: record.6,
        status: record.7,
        location_lat: record.8,
        location_lng: record.9,
        photo_url: record.10,
        notes: record.11,
        working_hours,
        is_late,
        created_at: record.12,
    })
}

fn calculate_working_hours(clock_in: &str, clock_out: &str) -> AppResult<String> {
    let clock_in_dt = DateTime::parse_from_rfc3339(clock_in)
        .map_err(|_| AppError::BadRequest("Invalid clock-in time format".to_string()))?;
    let clock_out_dt = DateTime::parse_from_rfc3339(clock_out)
        .map_err(|_| AppError::BadRequest("Invalid clock-out time format".to_string()))?;
    
    let duration = clock_out_dt.signed_duration_since(clock_in_dt);
    let hours = duration.num_minutes() as f64 / 60.0;
    
    Ok(format!("{:.1} jam", hours))
}
