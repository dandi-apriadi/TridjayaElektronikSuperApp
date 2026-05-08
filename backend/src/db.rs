use crate::models::{Branch, User, UserRole};
use anyhow::Result;
use bcrypt::{hash, DEFAULT_COST};
use chrono::Utc;
use sqlx::{migrate::MigrateDatabase, sqlite::SqlitePoolOptions, Pool, Sqlite};
use uuid::Uuid;

pub async fn init_db(database_url: &str) -> Result<Pool<Sqlite>> {
    // Create database if not exists
    if !Sqlite::database_exists(database_url).await.unwrap_or(false) {
        Sqlite::create_database(database_url).await?;
    }

    let pool = SqlitePoolOptions::new()
        .max_connections(10)
        .connect(database_url)
        .await?;

    // Run migrations
    run_migrations(&pool).await?;

    Ok(pool)
}

async fn run_migrations(pool: &Pool<Sqlite>) -> Result<()> {
    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS branches (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            address TEXT,
            phone TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
        "#,
    )
    .execute(pool)
    .await?;

    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            username TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            role TEXT NOT NULL,
            branch_id TEXT,
            is_active BOOLEAN DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (branch_id) REFERENCES branches(id)
        )
        "#,
    )
    .execute(pool)
    .await?;

    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS refresh_tokens (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            token TEXT UNIQUE NOT NULL,
            expires_at DATETIME NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        "#,
    )
    .execute(pool)
    .await?;

    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS password_reset_otps (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            otp TEXT NOT NULL,
            expires_at DATETIME NOT NULL,
            used BOOLEAN DEFAULT 0,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
        "#,
    )
    .execute(pool)
    .await?;

    // Create index for faster lookups
    sqlx::query(
        r#"
        CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
        CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);
        CREATE INDEX IF NOT EXISTS idx_password_reset_otps_user ON password_reset_otps(user_id);
        "#,
    )
    .execute(pool)
    .await?;

    Ok(())
}

pub async fn seed_data(pool: &Pool<Sqlite>) -> Result<()> {
    let existing_count: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM users")
        .fetch_one(pool)
        .await?;

    if existing_count > 0 {
        return Ok(());
    }

    println!("Seeding initial data...");

    // Create main branch
    let branch_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT INTO branches (id, name, address, phone)
        VALUES (?1, ?2, ?3, ?4)
        "#,
    )
    .bind(&branch_id)
    .bind("Kantor Pusat")
    .bind("Jl. Sudirman No. 123, Jakarta")
    .bind("021-1234567")
    .execute(pool)
    .await?;

    // Create cabang branch
    let cabang_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT INTO branches (id, name, address, phone)
        VALUES (?1, ?2, ?3, ?4)
        "#,
    )
    .bind(&cabang_id)
    .bind("Cabang Bandung")
    .bind("Jl. Dago No. 45, Bandung")
    .bind("022-7654321")
    .execute(pool)
    .await?;

    // Create users for all roles
    let users = vec![
        ("owner", "123456", UserRole::Owner, None::<String>),
        ("kepala_cabang", "123456", UserRole::KepalaCabang, Some(cabang_id.clone())),
        ("admin", "123456", UserRole::Admin, Some(branch_id.clone())),
        ("sales1", "123456", UserRole::Sales, Some(cabang_id.clone())),
        ("sales2", "123456", UserRole::Sales, Some(branch_id.clone())),
        ("driver1", "123456", UserRole::Driver, Some(cabang_id.clone())),
        ("driver2", "123456", UserRole::Driver, Some(branch_id.clone())),
    ];

    for (username, password, role, branch) in users {
        let password_hash = hash(password, DEFAULT_COST)?;
        let user_id = Uuid::new_v4().to_string();
        let now = Utc::now();

        sqlx::query(
            r#"
            INSERT INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
            VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)
            "#,
        )
        .bind(&user_id)
        .bind(username)
        .bind(&password_hash)
        .bind(role.as_str())
        .bind(&branch)
        .bind(true)
        .bind(&now)
        .bind(&now)
        .execute(pool)
        .await?;
    }

    println!("Seed data completed!");
    println!("\nDefault users created:");
    println!("  - owner / 123456 (Owner)");
    println!("  - kepala_cabang / 123456 (Kepala Cabang)");
    println!("  - admin / 123456 (Admin)");
    println!("  - sales1 / 123456 (Sales - Cabang Bandung)");
    println!("  - sales2 / 123456 (Sales - Kantor Pusat)");
    println!("  - driver1 / 123456 (Driver - Cabang Bandung)");
    println!("  - driver2 / 123456 (Driver - Kantor Pusat)");

    Ok(())
}

pub async fn get_user_by_username(pool: &Pool<Sqlite>, username: &str) -> Result<Option<User>, sqlx::Error> {
    sqlx::query_as::<_, User>(
        r#"
        SELECT id, username, password_hash, role, branch_id, is_active, created_at, updated_at
        FROM users
        WHERE username = ?1 AND is_active = 1
        "#,
    )
    .bind(username)
    .fetch_optional(pool)
    .await
}

pub async fn get_branch_by_id(pool: &Pool<Sqlite>, branch_id: &str) -> Result<Option<Branch>, sqlx::Error> {
    sqlx::query_as::<_, Branch>(
        r#"
        SELECT id, name, address, phone, created_at
        FROM branches
        WHERE id = ?1
        "#,
    )
    .bind(branch_id)
    .fetch_optional(pool)
    .await
}

pub async fn update_user_password(
    pool: &Pool<Sqlite>,
    user_id: &str,
    new_password_hash: &str,
) -> Result<(), sqlx::Error> {
    let now = Utc::now();
    sqlx::query(
        r#"
        UPDATE users
        SET password_hash = ?1, updated_at = ?2
        WHERE id = ?3
        "#,
    )
    .bind(new_password_hash)
    .bind(&now)
    .bind(user_id)
    .execute(pool)
    .await?;
    Ok(())
}
