mod config;
mod db;
mod error;
mod handlers;
mod middleware;
mod models;
mod utils;

use axum::{
    routing::{get, post},
    Router,
};
use std::net::SocketAddr;
use std::sync::Arc;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace::TraceLayer;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;
use sqlx::{Pool, Sqlite};

#[derive(Clone)]
pub struct AppState {
    pub pool: Pool<Sqlite>,
    pub config: Arc<config::Config>,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(subscriber)?;

    let config = Arc::new(config::Config::from_env()?);
    info!("Starting TE SuperApp Backend on port {}", config.port);

    let pool = db::init_db(&config.database_url).await?;
    info!("Database initialized");

    db::seed_data(&pool).await?;
    info!("Seed data applied");

    let state = Arc::new(AppState { pool, config });

    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    let auth_layer = axum::middleware::from_fn_with_state(
        Arc::clone(&state),
        middleware::auth_middleware,
    );

    let protected_routes = Router::new()
        .route("/api/owner/dashboard", get(handlers::owner::get_dashboard_metrics))
        .route("/api/owner/sales-ranking", get(handlers::owner::get_sales_ranking))
        .route("/api/owner/branches", get(handlers::owner::get_all_branches))
        .route("/api/owner/branches/:id", get(handlers::owner::get_branch_detail))
        .route("/api/owner/jobdesk/all", get(handlers::jobdesk::get_all_assignments))
        .route("/api/owner/jobdesk/stats", get(handlers::jobdesk::get_jobdesk_stats))
        .route("/api/kepala-cabang/dashboard", get(handlers::kepala_cabang::get_branch_dashboard))
        .route("/api/kepala-cabang/employees", get(handlers::kepala_cabang::get_branch_employees))
        .route("/api/kepala-cabang/jobdesk/pending", get(handlers::kepala_cabang::get_pending_jobdesk))
        .route("/api/kepala-cabang/jobdesk/:id/approve", post(handlers::kepala_cabang::approve_jobdesk))
        .route("/api/kepala-cabang/jobdesk/:id/reject", post(handlers::kepala_cabang::reject_jobdesk))
        .route("/api/kepala-cabang/work-reports/pending", get(handlers::kepala_cabang::get_pending_work_reports))
        .route("/api/kepala-cabang/work-reports/:id/approve", post(handlers::kepala_cabang::approve_work_report))
        .route("/api/kepala-cabang/work-reports/:id/reject", post(handlers::kepala_cabang::reject_work_report))
        .route("/api/kepala-cabang/attendance", get(handlers::kepala_cabang::get_attendance_summary))
        .route("/api/jobdesk/assignments/my", get(handlers::jobdesk::get_my_assignments))
        .route("/api/jobdesk/assignments/:id", get(handlers::jobdesk::get_jobdesk_detail))
        .route("/api/jobdesk/assignments/:id/submit", post(handlers::jobdesk::submit_jobdesk))
        .route("/api/jobdesk/assignments", get(handlers::jobdesk::get_all_assignments))
        .route("/api/jobdesk/assignments", post(handlers::jobdesk::create_jobdesk))
        .route("/api/jobdesk/pending-review", get(handlers::jobdesk::get_pending_review))
        .route("/api/jobdesk/:id/review", post(handlers::jobdesk::review_jobdesk))
        .route("/api/jobdesk/stats", get(handlers::jobdesk::get_jobdesk_stats))
        .route("/api/jobdesk/templates/my", get(handlers::jobdesk::get_my_templates))
        .route("/api/jobdesk/templates", get(handlers::jobdesk::get_all_templates))
        .route("/api/jobdesk/upload", post(handlers::jobdesk::upload_proof))
        .route("/api/jobdesk/proofs/:id", get(handlers::jobdesk::get_proof))
        .route("/api/jobdesk/proofs/:id/convert-webp", post(handlers::jobdesk::convert_to_webp))
        .layer(auth_layer);

    let app = Router::new()
        .route("/api/health", get(handlers::health_check))
        .route("/api/ping", get(handlers::ping))
        .route("/api/auth/login", post(handlers::auth::login))
        .route("/api/auth/logout", post(handlers::auth::logout))
        .route("/api/auth/refresh", post(handlers::auth::refresh_token))
        .route("/api/auth/password-reset/request", post(handlers::auth::password_reset_request))
        .route("/api/auth/password-reset/verify", post(handlers::auth::password_reset_verify))
        .merge(protected_routes)
        .layer(cors)
        .layer(TraceLayer::new_for_http())
        .with_state(Arc::clone(&state));

    let addr = SocketAddr::from(([0, 0, 0, 0], state.config.port));
    info!("Server listening on http://{}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
