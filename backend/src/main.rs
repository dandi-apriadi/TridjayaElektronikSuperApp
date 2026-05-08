mod config;
mod db;
mod error;
mod handlers;
mod middleware;
mod models;
mod utils;

use axum::{
    routing::post,
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
struct AppState {
    pool: Pool<Sqlite>,
    config: Arc<config::Config>,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize tracing
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(subscriber)?;

    // Load config
    let config = Arc::new(config::Config::from_env()?);
    info!("Starting TE SuperApp Backend on port {}", config.port);

    // Initialize database
    let pool = db::init_db(&config.database_url).await?;
    info!("Database initialized");

    // Seed initial data
    db::seed_data(&pool).await?;
    info!("Seed data applied");

    let state = AppState { pool, config };

    // CORS layer
    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    // Build router
    let app = Router::new()
        // Auth routes
        .route("/api/auth/login", post(handlers::auth::login))
        .route("/api/auth/logout", post(handlers::auth::logout))
        .route("/api/auth/refresh", post(handlers::auth::refresh_token))
        .route("/api/auth/password-reset/request", post(handlers::auth::password_reset_request))
        .route("/api/auth/password-reset/verify", post(handlers::auth::password_reset_verify))
        .layer(cors)
        .layer(TraceLayer::new_for_http())
        .with_state(state);

    let addr = SocketAddr::from(([0, 0, 0, 0], state.config.port));
    info!("Server listening on http://{}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
