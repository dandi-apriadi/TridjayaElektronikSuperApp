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
    let password_hash = match hash("password123", DEFAULT_COST) {
        Ok(h) => h,
        Err(e) => {
            eprintln!("❌ Failed to hash password: {}", e);
            return Err(sqlx::Error::Io(std::io::Error::new(
                std::io::ErrorKind::Other,
                format!("Password hashing failed: {}", e)
            )));
        }
    };
    
    // Seed divisions first
    seed_divisions(pool).await?;
    
    // Seed branches
    seed_branches(pool).await?;
    
    // Seed users with divisions
    seed_users(pool, &password_hash).await?;
    
    // Seed jobdesk templates
    seed_jobdesk_templates(pool).await?;
    
    // Seed test data for dashboard APIs
    seed_jobdesk_assignments(pool).await?;
    seed_work_reports(pool).await?;
    seed_payroll_records(pool).await?;
    seed_attendance(pool).await?;
    
    println!("✅ Database seeded successfully!");
    println!("\n🔐 Test Credentials:");
    println!("  Owner:           username=owner,            password=password123");
    println!("  Pak Kevin (PIC): username=pakkevin,         password=password123");
    println!("  Admin:           username=admin,            password=password123");
    println!("  Sales 1:         username=sales1,           password=password123");
    println!("  Sales 2:         username=sales2,           password=password123");
    println!("  Driver 1:        username=driver1,          password=password123");
    println!("  Driver 2:        username=driver2,          password=password123");
    println!("  Teknisi:         username=teknisi,          password=password123");
    println!("  Gudang:          username=gudang,           password=password123");
    println!("  Kasir:           username=kasir,            password=password123");
    println!("  Marketing:       username=marketing,        password=password123");
    println!("  CS:              username=cs,               password=password123");
    
    Ok(())
}

async fn seed_divisions(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let divisions = vec![
        ("div-001", "SALES", "Sales", "Tim penjualan dan marketing produk"),
        ("div-002", "DRIVER", "Driver", "Tim pengiriman dan logistik"),
        ("div-003", "TEKNISI", "Teknisi", "Tim teknisi dan service produk"),
        ("div-004", "GUDANG", "Gudang", "Tim manajemen gudang dan inventory"),
        ("div-005", "ADMIN", "Admin", "Tim administrasi dan operasional"),
        ("div-006", "KASIR", "Kasir", "Tim kasir dan transaksi"),
        ("div-007", "MARKETING", "Marketing", "Tim pemasaran digital dan promosi"),
        ("div-008", "CS", "Customer Service", "Tim layanan pelanggan"),
        ("div-009", "KEPALA", "Kepala Cabang", "PIC dan manajer cabang"),
        ("div-010", "OWNER", "Owner", "Pemilik perusahaan"),
    ];
    
    for (id, code, name, description) in divisions {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO divisions (id, code, name, description, is_active, created_at)
            VALUES (?, ?, ?, ?, 1, ?)
            "#
        )
        .bind(id)
        .bind(code)
        .bind(name)
        .bind(description)
        .bind(Utc::now())
        .execute(pool)
        .await?;
    }
    
    println!("✅ Divisions seeded");
    Ok(())
}

async fn seed_branches(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let branches = vec![
        ("branch-001", "BDG", "Cabang Bandung", "Jl. Sudirman No. 123, Bandung", "022-1234567", "bandung@tridjaya.id"),
        ("branch-002", "JKT", "Cabang Jakarta", "Jl. Thamrin No. 45, Jakarta", "021-7654321", "jakarta@tridjaya.id"),
        ("branch-003", "SBY", "Cabang Surabaya", "Jl. Pemuda No. 78, Surabaya", "031-9876543", "surabaya@tridjaya.id"),
    ];
    
    for (id, code, name, address, phone, email) in branches {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO branches (id, code, name, address, phone, email, is_active, manager_id, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, 1, NULL, ?, ?)
            "#
        )
        .bind(id)
        .bind(code)
        .bind(name)
        .bind(address)
        .bind(phone)
        .bind(email)
        .bind(Utc::now())
        .bind(Utc::now())
        .execute(pool)
        .await?;
    }
    
    println!("✅ Branches seeded");
    Ok(())
}

async fn seed_users(pool: &SqlitePool, password_hash: &str) -> Result<(), sqlx::Error> {
    let users = vec![
        // Owner (div-010)
        ("user-001", "owner", "Owner Tridjaya", "owner@tridjaya.id", "Owner", "div-010", None::<&str>, "081234567001"),
        // Pak Kevin - PIC Pelaporan (verifikasi semua divisi)
        ("user-002", "pakkevin", "Pak Kevin", "kevin@tridjaya.id", "PIC_Pelaporan", "div-009", Some("branch-001"), "081234567002"),
        // Admin
        ("user-003", "admin", "Admin Office", "admin@tridjaya.id", "Admin", "div-005", Some("branch-001"), "081234567003"),
        // Sales team (div-001)
        ("user-004", "sales1", "Sales Satu", "sales1@tridjaya.id", "Sales", "div-001", Some("branch-001"), "081234567004"),
        ("user-005", "sales2", "Sales Dua", "sales2@tridjaya.id", "Sales", "div-001", Some("branch-001"), "081234567005"),
        ("user-006", "sales3", "Sales Tiga", "sales3@tridjaya.id", "Sales", "div-001", Some("branch-002"), "081234567006"),
        // Driver team (div-002)
        ("user-007", "driver1", "Driver Satu", "driver1@tridjaya.id", "Driver", "div-002", Some("branch-001"), "081234567007"),
        ("user-008", "driver2", "Driver Dua", "driver2@tridjaya.id", "Driver", "div-002", Some("branch-001"), "081234567008"),
        ("user-009", "driver3", "Driver Tiga", "driver3@tridjaya.id", "Driver", "div-002", Some("branch-002"), "081234567009"),
        // Teknisi (div-003)
        ("user-010", "teknisi1", "Teknisi Satu", "teknisi1@tridjaya.id", "Teknisi", "div-003", Some("branch-001"), "081234567010"),
        ("user-011", "teknisi2", "Teknisi Dua", "teknisi2@tridjaya.id", "Teknisi", "div-003", Some("branch-001"), "081234567011"),
        // Gudang (div-004)
        ("user-012", "gudang1", "Staff Gudang 1", "gudang1@tridjaya.id", "Gudang", "div-004", Some("branch-001"), "081234567012"),
        ("user-013", "gudang2", "Staff Gudang 2", "gudang2@tridjaya.id", "Gudang", "div-004", Some("branch-001"), "081234567013"),
        // Kasir (div-006)
        ("user-014", "kasir1", "Kasir Satu", "kasir1@tridjaya.id", "Kasir", "div-006", Some("branch-001"), "081234567014"),
        ("user-015", "kasir2", "Kasir Dua", "kasir2@tridjaya.id", "Kasir", "div-006", Some("branch-002"), "081234567015"),
        // Marketing (div-007)
        ("user-016", "marketing1", "Marketing Satu", "marketing1@tridjaya.id", "Marketing", "div-007", Some("branch-001"), "081234567016"),
        ("user-017", "marketing2", "Marketing Dua", "marketing2@tridjaya.id", "Marketing", "div-007", Some("branch-001"), "081234567017"),
        // Customer Service (div-008)
        ("user-018", "cs1", "CS Satu", "cs1@tridjaya.id", "CS", "div-008", Some("branch-001"), "081234567018"),
        ("user-019", "cs2", "CS Dua", "cs2@tridjaya.id", "CS", "div-008", Some("branch-001"), "081234567019"),
        // Kepala Cabang lain
        ("user-020", "kcjakarta", "KC Jakarta", "kcjakarta@tridjaya.id", "KepalaCabang", "div-009", Some("branch-002"), "081234567020"),
        ("user-021", "kcsurabaya", "KC Surabaya", "kcsurabaya@tridjaya.id", "KepalaCabang", "div-009", Some("branch-003"), "081234567021"),
    ];
    
    for (id, username, full_name, email, role, division_id, branch_id, phone) in users {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO users (id, username, email, password_hash, full_name, role, division_id, branch_id, phone, is_active, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?)
            "#
        )
        .bind(id)
        .bind(username)
        .bind(email)
        .bind(password_hash)
        .bind(full_name)
        .bind(role)
        .bind(division_id)
        .bind(branch_id)
        .bind(phone)
        .bind(Utc::now())
        .bind(Utc::now())
        .execute(pool)
        .await?;
    }

    sqlx::query(
        r#"
        UPDATE users
        SET role = 'PIC_Pelaporan', updated_at = ?
        WHERE id = 'user-002' OR username = 'pakkevin' OR email = 'kevin@tridjaya.id'
        "#
    )
    .bind(Utc::now())
    .execute(pool)
    .await?;
    
    println!("✅ Users seeded (21 users)");
    Ok(())
}

async fn seed_jobdesk_templates(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let templates = vec![
        // Sales templates (div-001)
        ("tmpl-001", "div-001", "Kunjungan Pelanggan", "Kunjungan ke lokasi pelanggan untuk presentasi produk", "1. Datang ke lokasi\n2. Presentasi produk\n3. Ambil foto/video", 1, 1, 0),
        ("tmpl-002", "div-001", "Follow Up Prospect", "Follow up pelanggan prospek via WhatsApp/telepon", "1. Hubungi prospek\n2. Catat hasil percakapan\n3. Upload screenshot", 1, 0, 1),
        ("tmpl-003", "div-001", "Input Data Penjualan", "Input data penjualan harian ke sistem", "1. Kumpulkan nota\n2. Input ke sistem\n3. Upload nota", 1, 0, 0),
        
        // Driver templates (div-002)
        ("tmpl-004", "div-002", "Pengiriman Barang", "Antar barang ke pelanggan", "1. Ambil barang di gudang\n2. Foto barang sebelum berangkat\n3. Antar ke pelanggan\n4. Foto tanda terima", 1, 1, 0),
        ("tmpl-005", "div-002", "Pickup Barang", "Ambil barang return dari pelanggan", "1. Ke lokasi pelanggan\n2. Cek kondisi barang\n3. Ambil foto\n4. Bawa ke gudang", 1, 1, 0),
        ("tmpl-006", "div-002", "Perjalanan Dinas", "Perjalanan dinas luar kota", "1. Foto KM awal\n2. Foto perjalanan\n3. Foto KM akhir\n4. Upload struk BBM", 1, 1, 0),
        
        // Teknisi templates (div-003)
        ("tmpl-007", "div-003", "Service Produk", "Service/perbaikan produk pelanggan", "1. Cek kerusakan\n2. Foto produk\n3. Video proses perbaikan\n4. Test hasil", 1, 1, 0),
        ("tmpl-008", "div-003", "Instalasi Produk", "Instalasi produk baru di lokasi", "1. Foto lokasi\n2. Video instalasi\n3. Foto hasil akhir\n4. Test fungsi", 1, 1, 0),
        ("tmpl-009", "div-003", "Maintenance Rutin", "Maintenance berkala peralatan", "1. Foto kondisi awal\n2. Video proses\n3. Foto setelah maintenance", 1, 1, 0),
        
        // Gudang templates (div-004)
        ("tmpl-010", "div-004", "Input Barang Masuk", "Input barang masuk ke sistem", "1. Terima barang\n2. Cek fisik\n3. Foto barang\n4. Input data", 1, 0, 0),
        ("tmpl-011", "div-004", "Packing Order", "Packing barang untuk pengiriman", "1. Ambil barang\n2. Foto barang\n3. Video proses packing\n4. Foto paket jadi", 1, 1, 0),
        ("tmpl-012", "div-004", "Stock Opname", "Cek stok barang periodik", "1. Scan lokasi\n2. Hitung fisik\n3. Foto area\n4. Input selisih", 1, 0, 0),
        
        // Admin templates (div-005)
        ("tmpl-013", "div-005", "Rekap Harian", "Rekap data harian cabang", "1. Kumpulkan data\n2. Buat laporan\n3. Upload PDF laporan", 1, 0, 0),
        ("tmpl-014", "div-005", "Arsip Dokumen", "Scan dan arsip dokumen", "1. Scan dokumen\n2. Upload PDF\n3. Indexing file", 1, 0, 0),
        
        // Kasir templates (div-006)
        ("tmpl-015", "div-006", "Closing Kasir", "Closing kasir harian", "1. Hitung uang fisik\n2. Cocokkan sistem\n3. Foto struk\n4. Setor ke rekening", 1, 0, 0),
        ("tmpl-016", "div-006", "Rekap Transaksi", "Rekap transaksi harian", "1. Print laporan\n2. Cocokkan nominal\n3. Upload laporan", 1, 0, 0),
        
        // Marketing templates (div-007)
        ("tmpl-017", "div-007", "Konten Social Media", "Buat konten untuk social media", "1. Ambil foto produk\n2. Edit konten\n3. Upload draft\n4. Posting", 1, 1, 0),
        ("tmpl-018", "div-007", "Promo Event", "Dokumentasi event promo", "1. Foto booth\n2. Video suasana\n3. Foto interaksi\n4. Upload hasil", 1, 1, 0),
        
        // CS templates (div-008)
        ("tmpl-019", "div-008", "Handle Komplain", "Handle komplain pelanggan", "1. Catat komplain\n2. Follow up\n3. Upload screenshot WA\n4. Konfirmasi resolusi", 1, 0, 1),
        ("tmpl-020", "div-008", "Survey Kepuasan", "Survey kepuasan pelanggan", "1. Hubungi pelanggan\n2. Isi form survey\n3. Upload hasil\n4. Rekap data", 1, 0, 0),
    ];
    
    for (id, division_id, title, description, instructions, allow_photo, allow_video, allow_no_attachment) in templates {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO jobdesk_templates (id, division_id, title, description, instructions, allow_photo, allow_video, allow_no_attachment, is_active, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)
            "#
        )
        .bind(id)
        .bind(division_id)
        .bind(title)
        .bind(description)
        .bind(instructions)
        .bind(allow_photo)
        .bind(allow_video)
        .bind(allow_no_attachment)
        .bind(Utc::now())
        .execute(pool)
        .await?;
    }
    
    println!("✅ Jobdesk templates seeded (20 templates)");
    Ok(())
}

async fn seed_jobdesk_assignments(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let today = Utc::now().date_naive();
    let now = Utc::now();
    
    // Test data dengan berbagai status untuk testing alur lengkap
    // Pak Kevin (user-002) sebagai assigner dan reviewer
    let assignments = vec![
        // 1. APPROVED - Sudah diapprove Pak Kevin (untuk stats)
        ("jd-001", Some("tmpl-001"), "user-004", "user-002", "branch-001", 
         "Kunjungan Pelanggan - PT Maju Jaya", "Kunjungan presentasi produk AC", 
         today, today, "normal", "approved", Some(now), Some("Sudah presentasi dan klien tertarik"), 
         1, Some("user-002"), Some(now), Some("Bagus, lanjutkan follow up"), None),
        
        // 2. APPROVED - Driver
        ("jd-002", Some("tmpl-004"), "user-007", "user-002", "branch-001", 
         "Pengiriman ke Jl. Sudirman", "Pengiriman 3 unit AC", 
         today, today, "normal", "approved", Some(now), Some("Paket sudah diterima dengan baik"), 
         1, Some("user-002"), Some(now), Some("Good job"), None),
        
        // 3. SUBMITTED - Menunggu review Pak Kevin
        ("jd-003", Some("tmpl-002"), "user-004", "user-002", "branch-001", 
         "Follow Up Pak Budi", "Follow up via WhatsApp", 
         today, today, "high", "submitted", Some(now), Some("Sudah follow up, masih negosiasi harga"), 
         0, None, None, None, None),
        
        // 4. SUBMITTED - Driver dengan attachment
        ("jd-004", Some("tmpl-005"), "user-007", "user-002", "branch-001", 
         "Pickup barang return", "Pickup kulkas return dari klien", 
         today, today, "normal", "submitted", Some(now), Some("Barang sudah diambil dan dicek"), 
         1, None, None, None, None),
        
        // 5. ASSIGNED - Belum dikerjakan
        ("jd-005", Some("tmpl-007"), "user-010", "user-002", "branch-001", 
         "Service AC Pak Surya", "Service rutin AC 1.5 PK", 
         today, today, "urgent", "assigned", None, None, 
         0, None, None, None, None),
        
        // 6. ASSIGNED - Gudang
        ("jd-006", Some("tmpl-010"), "user-012", "user-002", "branch-001", 
         "Input barang masuk", "Input 50 unit AC baru", 
         today, today, "high", "assigned", None, None, 
         0, None, None, None, None),
        
        // 7. REJECTED - Perlu perbaikan
        ("jd-007", Some("tmpl-003"), "user-005", "user-002", "branch-001", 
         "Input data penjualan", "Input nota 10 transaksi hari ini", 
         today, today, "normal", "rejected", Some(now), Some("Sudah input tapi ada yang kurang"), 
         0, Some("user-002"), Some(now), None, Some("Kurang lengkap, tambahkan nomor nota yang hilang")),
        
        // 8. ASSIGNED - Marketing
        ("jd-008", Some("tmpl-017"), "user-016", "user-002", "branch-001", 
         "Konten Instagram", "Buat konten produk terbaru", 
         today, today, "normal", "assigned", None, None, 
         0, None, None, None, None),
        
        // 9. ASSIGNED - CS
        ("jd-009", Some("tmpl-019"), "user-018", "user-002", "branch-001", 
         "Handle komplain #1234", "Komplain AC tidak dingin", 
         today, today, "high", "assigned", None, None, 
         0, None, None, None, None),
        
        // 10. SUBMITTED - Teknisi dengan video
        ("jd-010", Some("tmpl-008"), "user-010", "user-002", "branch-001", 
         "Instalasi AC 2PK", "Instalasi di rumah Pak Ahmad", 
         today, today, "normal", "submitted", Some(now), Some("Instalasi selesai, test OK"), 
         1, None, None, None, None),
    ];
    
    for (id, template_id, user_id, assigner_id, branch_id, title, description, 
         assigned_date, due_date, priority, status, submitted_at, submitted_notes,
         has_attachments, reviewed_by, reviewed_at, review_notes, rejection_reason) in assignments {
        
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO jobdesk_assignments 
            (id, template_id, user_id, assigner_id, branch_id, title, description, 
             assigned_date, due_date, priority, status, submitted_at, submitted_notes,
             has_attachments, reviewed_by, reviewed_at, review_notes, rejection_reason)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            "#
        )
        .bind(id)
        .bind(template_id)
        .bind(user_id)
        .bind(assigner_id)
        .bind(branch_id)
        .bind(title)
        .bind(description)
        .bind(assigned_date)
        .bind(due_date)
        .bind(priority)
        .bind(status)
        .bind(submitted_at)
        .bind(submitted_notes)
        .bind(has_attachments)
        .bind(reviewed_by)
        .bind(reviewed_at)
        .bind(review_notes)
        .bind(rejection_reason)
        .execute(pool)
        .await?;
    }
    
    println!("✅ Jobdesk assignments seeded (10 test assignments)");
    println!("   - 2 Approved (sudah di-check Pak Kevin)");
    println!("   - 3 Submitted (menunggu review Pak Kevin)");
    println!("   - 4 Assigned (belum dikerjakan)");
    println!("   - 1 Rejected (perlu perbaikan)");
    
    Ok(())
}

async fn seed_work_reports(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let today = Utc::now().date_naive();
    
    let reports = vec![
        ("wr-001", "user-004", "branch-001", today, "Laporan harian sales", "submitted"),
        ("wr-002", "user-005", "branch-001", today, "Laporan pengiriman", "submitted"),
    ];
    
    for (id, user_id, branch_id, report_date, content, status) in reports {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO work_reports (id, user_id, branch_id, report_date, content, status, photos)
            VALUES (?, ?, ?, ?, ?, ?, '[]')
            "#
        )
        .bind(id)
        .bind(user_id)
        .bind(branch_id)
        .bind(report_date)
        .bind(content)
        .bind(status)
        .execute(pool)
        .await?;
    }
    
    Ok(())
}

async fn seed_payroll_records(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let now = Utc::now();
    
    // Create payroll records for sales to show revenue
    let payrolls = vec![
        ("pay-001", "user-004", 5, 2026, 5000000.0, 1000000.0, 0.0, 6000000.0, "paid"),
        ("pay-002", "user-005", 5, 2026, 4000000.0, 500000.0, 0.0, 4500000.0, "paid"),
    ];
    
    for (id, user_id, month, year, base, bonus, deductions, total, status) in payrolls {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO payroll_records (id, user_id, month, year, base_salary, bonus, deductions, total_amount, status, paid_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            "#
        )
        .bind(id)
        .bind(user_id)
        .bind(month)
        .bind(year)
        .bind(base)
        .bind(bonus)
        .bind(deductions)
        .bind(total)
        .bind(status)
        .bind(now)
        .execute(pool)
        .await?;
    }
    
    Ok(())
}

async fn seed_attendance(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let today = Utc::now().date_naive();
    
    // Mark some employees as present today
    let attendances = vec![
        ("att-001", "user-002", "branch-001", today, "present"),
        ("att-002", "user-004", "branch-001", today, "present"),
        ("att-003", "user-005", "branch-001", today, "present"),
    ];
    
    for (id, user_id, branch_id, date, status) in attendances {
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO attendance (id, user_id, branch_id, date, status)
            VALUES (?, ?, ?, ?, ?)
            "#
        )
        .bind(id)
        .bind(user_id)
        .bind(branch_id)
        .bind(date)
        .bind(status)
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
    ('user-002', 'kepalacabang', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'PIC_Pelaporan', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-003', 'admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Admin', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-004', 'sales', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Sales', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-005', 'driver', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Driver', 'branch-001', 1, datetime('now'), datetime('now'));

INSERT OR IGNORE INTO branches (id, name, address, phone, created_at)
VALUES 
    ('branch-001', 'Cabang Bandung', 'Jl. Sudirman No. 123, Bandung', '022-1234567', datetime('now')),
    ('branch-002', 'Cabang Jakarta', 'Jl. Thamrin No. 45, Jakarta', '021-7654321', datetime('now')),
    ('branch-003', 'Cabang Surabaya', 'Jl. Pemuda No. 78, Surabaya', '031-9876543', datetime('now'));
"#;
