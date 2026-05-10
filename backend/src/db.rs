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

    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS work_reports (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            branch_id TEXT NOT NULL,
            content TEXT NOT NULL,
            status TEXT DEFAULT 'pending',
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (branch_id) REFERENCES branches(id)
        )
        "#,
    )
    .execute(pool)
    .await?;

    sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS leave_requests (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            branch_id TEXT NOT NULL,
            reason TEXT NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            status TEXT DEFAULT 'pending',
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (branch_id) REFERENCES branches(id)
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
        CREATE INDEX IF NOT EXISTS idx_work_reports_user ON work_reports(user_id);
        CREATE INDEX IF NOT EXISTS idx_work_reports_branch ON work_reports(branch_id);
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

    println!("Seeding comprehensive initial data (16 branches, 350 employees, 1 year simulation)...");

    let branch_names = vec![
        "Tridjaya Elektronik Sam Ratulangi",
        "Tridjaya Elektronik Bahu",
        "Tridjaya Elektronik Pamanukan",
        "Tridjaya Elektronik Pagaden",
        "Tridjaya Elektronik Patokbeusi",
        "Tridjaya Elektronik Haurgeulis",
        "Tridjaya Elektronik Cimalaka",
        "Tridjaya Elektronik Cikampek",
        "Tridjaya Elektronik Cibaduyut",
        "Tridjaya Elektronik Arjasari",
        "Tridjaya Elektronik Subang Kota",
        "Tridjaya Elektronik Purwakarta",
        "Tridjaya Elektronik Sumedang Kota",
        "Tridjaya Elektronik Karawang",
        "Tridjaya Elektronik Indramayu Kota",
        "Tridjaya Elektronik Bandung Main",
    ];

    let mut branch_ids = Vec::new();

    for name in &branch_names {
        let id = Uuid::new_v4().to_string();
        sqlx::query(
            r#"
            INSERT INTO branches (id, name, address, phone)
            VALUES (?1, ?2, ?3, ?4)
            "#,
        )
        .bind(&id)
        .bind(*name)
        .bind(format!("Alamat {}, Jawa Barat", name))
        .bind("022-1234567")
        .execute(pool)
        .await?;
        branch_ids.push(id);
    }

    // Special Users
    let password_hash = hash("123456", DEFAULT_COST)?;
    
    // Owner
    sqlx::query("INSERT INTO users (id, username, password_hash, role, branch_id) VALUES (?1, ?2, ?3, ?4, ?5)")
        .bind(Uuid::new_v4().to_string())
        .bind("owner")
        .bind(&password_hash)
        .bind(UserRole::Owner.as_str())
        .bind(None::<String>)
        .execute(pool).await?;

    // PIC Pak Iwan at Sam Ratulangi (Branch index 0)
    sqlx::query("INSERT INTO users (id, username, password_hash, role, branch_id) VALUES (?1, ?2, ?3, ?4, ?5)")
        .bind(Uuid::new_v4().to_string())
        .bind("pak_iwan")
        .bind(&password_hash)
        .bind(UserRole::KepalaCabang.as_str())
        .bind(Some(&branch_ids[0]))
        .execute(pool).await?;

    // Generate 348 more users to reach 350
    use rand::Rng;
    let mut rng = rand::thread_rng();
    let roles = vec![UserRole::Sales, UserRole::Driver, UserRole::Admin, UserRole::KepalaCabang];
    
    let mut user_ids = Vec::new();

    for i in 1..=348 {
        let username = format!("user_{:03}", i);
        let role = &roles[rng.gen_range(0..roles.len())];
        let branch_id = &branch_ids[rng.gen_range(0..branch_ids.len())];
        let id = Uuid::new_v4().to_string();

        sqlx::query("INSERT INTO users (id, username, password_hash, role, branch_id) VALUES (?1, ?2, ?3, ?4, ?5)")
            .bind(&id)
            .bind(&username)
            .bind(&password_hash)
            .bind(role.as_str())
            .bind(Some(branch_id))
            .execute(pool).await?;
        
        user_ids.push((id, branch_id.clone(), role.clone()));
    }

    // Simulate 1 year of data (last 365 days)
    println!("Generating 1 year simulation data (this may take a few seconds)...");
    use chrono::Duration;
    let now = Utc::now();

    for (user_id, branch_id, role) in user_ids.iter().take(100) { // Limit to 100 users for simulation to avoid huge DB
        for d in 0..30 { // Simulate 30 random days in the last year for each user
            let days_ago = rng.gen_range(1..365);
            let date = now - Duration::days(days_ago);
            
            let status = if rng.gen_bool(0.8) { "approved" } else { "pending" };
            let content = match role {
                UserRole::Sales => "Melakukan kunjungan ke prospek konsumen dan follow up pembiayaan.",
                UserRole::Driver => "Pengiriman unit ke alamat konsumen dan pengecekan STNK.",
                UserRole::Admin => "Input data harian dan rekonsiliasi kas cabang.",
                _ => "Supervisi operasional harian cabang.",
            };

            sqlx::query("INSERT INTO work_reports (id, user_id, branch_id, content, status, created_at) VALUES (?1, ?2, ?3, ?4, ?5, ?6)")
                .bind(Uuid::new_v4().to_string())
                .bind(user_id)
                .bind(branch_id)
                .bind(content)
                .bind(status)
                .bind(date)
                .execute(pool).await?;
            
            // Randomly add leave requests
            if rng.gen_bool(0.05) {
                sqlx::query("INSERT INTO leave_requests (id, user_id, branch_id, reason, start_date, end_date, status, created_at) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)")
                    .bind(Uuid::new_v4().to_string())
                    .bind(user_id)
                    .bind(branch_id)
                    .bind("Izin kepentingan keluarga")
                    .bind(date.date_naive())
                    .bind((date + Duration::days(1)).date_naive())
                    .bind("approved")
                    .bind(date)
                    .execute(pool).await?;
            }
        }
    }

    println!("Comprehensive seed data completed!");
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
