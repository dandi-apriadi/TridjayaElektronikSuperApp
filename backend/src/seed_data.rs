use sqlx::SqlitePool;
use chrono::Utc;
use uuid::Uuid;
use bcrypt::{hash, DEFAULT_COST};

/// ============================================================
/// 🔐 SEED DATA - Login credentials for all roles
/// Run this to populate database with test users
/// ============================================================

pub async fn seed_database(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    println!("🌱 Seeding database with test users...");
    
    // Hash password: "password123"
    let password_hash = hash("password123", DEFAULT_COST).unwrap();
    
    // 1. OWNER (Pak Iwan)
    let owner_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
        VALUES (?, 'owner', ?, 'Owner', NULL, 1, ?, ?)
        "#
    )
    .bind(&owner_id)
    .bind(&password_hash)
    .bind(Utc::now())
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    // 2. KEPALA CABANG (Budi Wijaya)
    let kc_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
        VALUES (?, 'kepalacabang', ?, 'Kepala_Cabang', 'branch-001', 1, ?, ?)
        "#
    )
    .bind(&kc_id)
    .bind(&password_hash)
    .bind(Utc::now())
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    // 3. ADMIN (Dedi Kurniawan)
    let admin_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
        VALUES (?, 'admin', ?, 'Admin', 'branch-001', 1, ?, ?)
        "#
    )
    .bind(&admin_id)
    .bind(&password_hash)
    .bind(Utc::now())
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    // 4. SALES (Ahmad Santoso)
    let sales_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
        VALUES (?, 'sales', ?, 'Sales', 'branch-001', 1, ?, ?)
        "#
    )
    .bind(&sales_id)
    .bind(&password_hash)
    .bind(Utc::now())
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    // 5. DRIVER (Citra Dewi)
    let driver_id = Uuid::new_v4().to_string();
    sqlx::query(
        r#"
        INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
        VALUES (?, 'driver', ?, 'Driver', 'branch-001', 1, ?, ?)
        "#
    )
    .bind(&driver_id)
    .bind(&password_hash)
    .bind(Utc::now())
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    // Seed branches
    seed_branches(pool).await?;
    
    println!("✅ Database seeded successfully!");
    println!("\n🔐 Test Credentials:");
    println!("  Owner:        username=owner,         password=password123");
    println!("  Kepala Cabang: username=kepalacabang,  password=password123");
    println!("  Admin:        username=admin,         password=password123");
    println!("  Sales:        username=sales,         password=password123");
    println!("  Driver:       username=driver,        password=password123");
    
    Ok(())
}

async fn seed_branches(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let branches = vec![
        ("branch-001", "Cabang Bandung", "Jl. Sudirman No. 123, Bandung", "022-1234567"),
        ("branch-002", "Cabang Jakarta", "Jl. Thamrin No. 45, Jakarta", "021-7654321"),
        ("branch-003", "Cabang Surabaya", "Jl. Pemuda No. 78, Surabaya", "031-9876543"),
    ];
    
    for (id, name, address, phone) in branches {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO branches (id, name, address, phone, created_at)
            VALUES (?, ?, ?, ?, ?)
            "#
        )
        .bind(id)
        .bind(name)
        .bind(address)
        .bind(phone)
        .bind(Utc::now())
        .execute(pool)
        .await?;
    }
    
    Ok(())
}

/// SQL for manual insertion (if needed)
pub const SEED_SQL: &str = r#"
-- Test Users with password: password123
-- Password hash: $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e

INSERT OR IGNORE INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
VALUES 
    ('user-001', 'owner', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Owner', NULL, 1, datetime('now'), datetime('now')),
    ('user-002', 'kepalacabang', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Kepala_Cabang', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-003', 'admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Admin', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-004', 'sales', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Sales', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-005', 'driver', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Driver', 'branch-001', 1, datetime('now'), datetime('now'));

INSERT OR IGNORE INTO branches (id, name, address, phone, created_at)
VALUES 
    ('branch-001', 'Cabang Bandung', 'Jl. Sudirman No. 123, Bandung', '022-1234567', datetime('now')),
    ('branch-002', 'Cabang Jakarta', 'Jl. Thamrin No. 45, Jakarta', '021-7654321', datetime('now')),
    ('branch-003', 'Cabang Surabaya', 'Jl. Pemuda No. 78, Surabaya', '031-9876543', datetime('now'));
"#;
