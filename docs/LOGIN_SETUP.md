# 🔐 Setup Login Database - ERP Tridjaya SuperApp

## Data Login untuk Semua Role

### 📋 Cara 1: Jalankan SQL File (Cepat)

```bash
# Di folder backend
sqlite3 te_superapp.db < SEED_DATABASE.txt
```

Atau jalankan di terminal SQLite:
```sql
.read SEED_DATABASE.txt
```

### 📋 Cara 2: Jalankan Rust Seeder (Otomatis)

Tambahkan ke `main.rs`:

```rust
mod seed_data;

#[tokio::main]
async fn main() {
    let pool = SqlitePool::connect("sqlite:te_superapp.db").await.unwrap();
    
    // Seed database with test users
    seed_data::seed_database(&pool).await.unwrap();
    
    // ... rest of your code
}
```

Tambahkan dependency di `Cargo.toml`:
```toml
[dependencies]
bcrypt = "0.15"
```

### 📋 Cara 3: Manual Insert (SQL)

Copy-paste SQL berikut ke database client Anda:

```sql
-- Branches
INSERT INTO branches (id, name, address, phone, created_at)
VALUES 
    ('branch-001', 'Cabang Bandung', 'Jl. Sudirman No. 123', '022-1234567', datetime('now')),
    ('branch-002', 'Cabang Jakarta', 'Jl. Thamrin No. 45', '021-7654321', datetime('now'));

-- Users (password: password123)
INSERT INTO users (id, username, password_hash, role, branch_id, is_active, created_at, updated_at)
VALUES 
    ('user-001', 'owner', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Owner', NULL, 1, datetime('now'), datetime('now')),
    ('user-002', 'kepalacabang', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Kepala_Cabang', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-003', 'admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Admin', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-004', 'sales', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Sales', 'branch-001', 1, datetime('now'), datetime('now')),
    ('user-005', 'driver', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e', 'Driver', 'branch-001', 1, datetime('now'), datetime('now'));
```

---

## 🔐 Test Credentials

| Role | Username | Password | Branch | Dashboard |
|------|----------|----------|--------|-----------|
| **Owner** | `owner` | `password123` | All | `/owner` |
| **Kepala Cabang** | `kepalacabang` | `password123` | Cabang Bandung | `/kepala-cabang` |
| **Admin** | `admin` | `password123` | Cabang Bandung | `/admin` |
| **Sales** | `sales` | `password123` | Cabang Bandung | `/sales` |
| **Driver** | `driver` | `password123` | Cabang Bandung | `/driver` |
| **Super Admin** | `superadmin` | `password123` | All | `/superadmin` |

---

## 🔑 Password Hash

- **Password**: `password123`
- **Hash (bcrypt)**: `$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewKyNiAYMyzJ/I1e`

Jika ingin generate hash baru:
```bash
# Install bcrypt-cli
npm install -g bcrypt-cli

# Generate hash
bcrypt password123
```

---

## ✅ Verifikasi Login

Setelah seeding, test login dengan:

```bash
# Test Owner
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"owner","password":"password123"}'

# Test Sales
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"sales","password":"password123"}'
```

---

## ⚠️ Production Note

**Ganti password default sebelum deploy ke production!**
