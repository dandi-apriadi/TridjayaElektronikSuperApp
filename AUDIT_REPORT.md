# Audit Keamanan & Bug Report - TE SuperApp
**Tanggal:** 11 Mei 2026
**Lingkup:** Backend (Rust/Axum) + Mobile (Flutter) + Database

---

## Ringkasan Eksekutif

| Kategori | Jumlah |
|----------|--------|
| Critical | 4 |
| High | 6 |
| Medium | 5 |
| Low | 3 |
| **Total** | **18** |

---

## Critical Issues

### 1. SQL Injection (Multiple Files)
**Status:** ⚠️ AKTIF - Dapat dieksploitasi

Banyak handler yang membangun query SQL secara dinamis dengan `format!` menggunakan parameter user input langsung tanpa prepared statement binding.

**File & Lokasi:**
- `backend/src/handlers/inventory.rs:135,141` - `category`, `branch_id` params
- `backend/src/handlers/inventory.rs:395,401,406,409` - `type`, `start_date`, `end_date`, `branch_id` params
- `backend/src/handlers/inventory.rs:443,455,486,491,505,512,519` - `severity`, `branch_id` params
- `backend/src/handlers/attendance.rs:262,267,272` - `status`, `start_date`, `end_date` params
- `backend/src/handlers/notification.rs:164,171,176,184,195` - `user_id`, `type`, `limit`, `offset` params
- `backend/src/handlers/work_report.rs:160,165,168,247,250,253,256,264` - `status`, `start_date`, `end_date`, `content`, `achievements`, `challenges`, `photos`
- `backend/src/handlers/jobdesk.rs:638,641,644,649` - `branch_id`, `status`, `user_id` params

**Contoh Kode Vulnerable:**
```rust
// backend/src/handlers/inventory.rs:140-142
if let Some(category) = params.get("category") {
    query.push_str(&format!(" AND category = '{}'", category)); // DANGER!
}
```

**Dampak:** Attacker bisa melakukan SQL injection, membaca data sensitif, memodifikasi database, atau menghapus data.

**Rekomendasi Fix:** Gunakan prepared statement dengan `.bind()` untuk SEMUA parameter dinamis.

```rust
// SAFE - gunakan placeholder dan bind
let mut query = String::from("SELECT * FROM inventory_items WHERE 1=1");
let mut binds: Vec<String> = vec![];

if let Some(category) = params.get("category") {
    query.push_str(" AND category = ?");
    binds.push(category.clone());
}
// ... bind semua parameter
```

---

### 2. JWT Secret Hardcoded
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `backend/src/config.rs:23` - Default JWT secret: `"your-secret-key-change-in-production"`
- `backend/src/middleware.rs:156` - Hardcoded fallback: `"te_superapp_secret_key_2024_very_long_and_secure"`

**Dampak:** Jika `JWT_SECRET` environment variable tidak di-set, attacker bisa membuat token JWT valid untuk semua user.

**Rekomendasi Fix:**
```rust
// config.rs - HAPUS default value, PANIC jika tidak di-set
pub fn from_env() -> Result<Self> {
    dotenv::dotenv().ok();
    let jwt_secret = std::env::var("JWT_SECRET")
        .expect("JWT_SECRET harus di-set di environment variables!");
    // ...
}
```

---

### 3. CORS Terlalu Permisif
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `backend/src/main.rs:45-48`

```rust
let cors = CorsLayer::new()
    .allow_origin(Any)
    .allow_methods(Any)
    .allow_headers(Any);
```

**Dampak:** Browser dari domain manapun bisa memanggil API, memudahkan serangan CSRF dan eksploitasi oleh malicious websites.

**Rekomendasi Fix:** Batasi origin ke domain aplikasi mobile/web yang valid.

```rust
let cors = CorsLayer::new()
    .allow_origin([
        "http://localhost:8080".parse().unwrap(),
        "https://tridjaya.id".parse().unwrap(),
    ])
    .allow_methods([Method::GET, Method::POST, Method::PUT, Method::DELETE])
    .allow_headers([header::AUTHORIZATION, header::CONTENT_TYPE]);
```

---

### 4. Error Message Bocor Informasi Database
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `backend/src/error.rs:57-64`

```rust
AppError::Database(_) => (
    StatusCode::INTERNAL_SERVER_ERROR,
    "Database error".to_string(), // Seharusnya tidak detail
),
AppError::DatabaseError(msg) => (
    StatusCode::INTERNAL_SERVER_ERROR,
    msg.clone(), // BOCOR! Pesan error DB asli ke client
),
```

**Dampak:** Attacker bisa mendapatkan struktur database, nama tabel, atau query yang salah.

**Rekomendasi Fix:** Jangan kirim pesan error internal ke client.

```rust
AppError::DatabaseError(_) => (
    StatusCode::INTERNAL_SERVER_ERROR,
    "Internal server error".to_string(),
),
```

---

## High Issues

### 5. Tidak Ada Rate Limiting
**Status:** ⚠️ AKTIF

Tidak ada rate limiting di endpoint login, OTP request, refresh token, atau API lainnya.

**Dampak:** Brute force attack pada login dan OTP, DoS attack.

**Rekomendasi:** Implementasi rate limiting menggunakan `tower-governor` atau middleware custom.

---

### 6. Mobile Stock Form Tidak Terhubung ke API
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `mobile/lib/features/admin/presentation/screens/inventory_screen.dart:351-413`

Form tambah/kurangi stok hanya menampilkan `SnackBar` tanpa memanggil API `addStockProvider` atau `removeStockProvider`.

```dart
onPressed: () {
  Navigator.pop(ctx);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(isAdd ? 'Stok berhasil ditambahkan' : 'Stok berhasil dikurangi'),
    // ... TIDAK ADA API CALL!
  ));
},
```

**Rekomendasi:** Hubungkan form ke `addStockProvider` / `removeStockProvider` yang sudah ada.

---

### 7. Seed Data Semua User Password Sama (Weak Password)
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `backend/src/db.rs:588`

```rust
let password_hash = hash("123", DEFAULT_COST)?;
```

Semua 350+ user dibuat dengan password `"123"`.

**Dampak:** Jika attacker mendapatkan satu credential, semua account bisa diakses.

**Rekomendasi:** Gunakan password yang kuat dan unik per user, atau wajibkan user mengganti password saat pertama login.

---

### 8. No Input Length Validation
**Status:** ⚠️ AKTIF

Banyak endpoint yang tidak melakukan validasi panjang/maximum input:
- `crm.rs` - `name`, `phone`, `notes` tidak ada batas panjang
- `sales.rs` - `name`, `phone`, `notes` tidak ada batas panjang
- `jobdesk.rs` - `title`, `description` tidak ada batas panjang
- `notification.rs` - `title`, `message` tidak ada batas panjang

**Dampak:** DoS via input besar, database bloat.

**Rekomendasi:** Tambahkan `#[validate(max_length = 255)]` atau validasi manual.

---

### 9. Missing Role Check di Beberapa Endpoint
**Status:** ⚠️ AKTIF

Beberapa endpoint tidak melakukan role check yang memadai:
- `crm::get_interactions` - Hanya memeriksa `customer_id` tanpa verifikasi ownership
- `schedule::assign_shift` - Admin bisa assign shift ke user manapun tanpa verifikasi cabang
- `driver::create_delivery` - `driver_id` di-set kosong string `bind("")` tanpa validasi

---

### 10. OTP Dicetak ke Log
**Status:** ⚠️ AKTIF

**File & Lokasi:**
- `backend/src/handlers/auth.rs:203`

```rust
tracing::info!("OTP for user {}: {}", user.username, otp);
```

OTP password reset dicetak ke log. Log bisa diakses oleh siapapun dengan akses ke server.

**Rekomendasi:** HAPUS baris ini atau ganti dengan `tracing::debug!` dan pastikan log production tidak mengandung data sensitif.

---

## Medium Issues

### 11. Dummy Data Files Masih Ada
**Status:** ⚠️ ADA TAPI TIDAK DIGUNAKAN

**File:**
- `mobile/lib/shared/dummy_data/dummy_data.dart`
- `mobile/lib/features/superadmin/data/superadmin_dummy_data.dart`

File ini masih ada di codebase meskipun sebagian sudah tidak digunakan. Risiko: developer baru bisa salah import dan menggunakan data dummy.

**Rekomendasi:** Hapus file dummy data yang tidak digunakan.

---

### 12. Hardcoded Values di Mobile
**Status:** ⚠️ ADA

**File & Lokasi:**
- `mobile/lib/features/jobdesk/presentation/screens/my_jobdesk_screen.dart:254` - `"Streak 5 Hari! 🔥"` hardcoded
- `mobile/lib/features/driver/...` (belum dicek) - kemungkinan ada hardcoded route data

---

### 13. Token Refresh Tidak Handle Concurrent Refresh
**Status:** ⚠️ ADA

**File & Lokasi:**
- `mobile/lib/core/network/dio_client.dart:242-261`

Jika multiple request gagal 401 secara bersamaan, masing-masing akan mencoba refresh token secara independent, menyebabkan race condition.

**Rekomendasi:** Gunakan `QueuedInterceptorsWrapper` atau mekanisme locking untuk mencegah concurrent refresh.

---

### 14. No HTTPS Enforcement
**Status:** ⚠️ ADA

Mobile menggunakan HTTP fallback (`http://10.0.2.2:8080/api`) untuk development. Tidak ada mekanisme untuk memastikan production menggunakan HTTPS.

**Rekomendasi:** Tambahkan assertion di build release untuk memastikan HTTPS digunakan.

---

### 15. No Request Validation di Notification Create
**Status:** ⚠️ ADA

**File & Lokasi:**
- `backend/src/handlers/notification.rs:68-77`

Notification create memeriksa role, tapi payload `serde_json::Value` tidak divalidasi. Field `user_id`, `type`, `title`, `message` diambil dari JSON tanpa sanitasi.

---

## Low Issues

### 16. Komentar TODO Tanpa Implementasi
**Status:** ADA

- `inventory_screen.dart:363` - `// TODO: populate from real items when implementing stock form with API`
- `auth.rs:201-203` - `// TODO: Send OTP via WhatsApp/SMS`

---

### 17. Duplicate ApiEndpoints Class
**Status:** ADA

Ada dua file dengan class `ApiEndpoints` yang berbeda:
- `mobile/lib/core/constants/app_constants.dart:28`
- `mobile/lib/core/constants/api_endpoints.dart:4`

Bisa menyebabkan inkonsistensi.

---

### 18. Missing Indexes pada Kolom Foreign Key
**Status:** SUDAH BAIK - Tapi perlu verifikasi

Schema database sudah memiliki banyak index. Pastikan semua FK yang sering di-query sudah ter-index.

---

## Rekomendasi Perbaikan Prioritas

### Sprint 1 (Critical - Harus Segera)
1. Fix semua SQL injection dengan prepared statement binding
2. Hapus/hardcoded JWT secret fallback
3. Restrict CORS ke domain yang diizinkan
4. Sembunyikan pesan error internal dari client response

### Sprint 2 (High)
5. Implementasi rate limiting (login, OTP)
6. Hubungkan mobile stock form ke real API
7. Hapus OTP logging dari production
8. Tambahkan input validation (length, format)

### Sprint 3 (Medium)
9. Hapus file dummy data yang tidak digunakan
10. Handle concurrent token refresh di mobile
11. Enforce HTTPS di production build
12. Tambahkan request validation struct untuk notification

---

*Report generated by code audit on TE SuperApp codebase*
