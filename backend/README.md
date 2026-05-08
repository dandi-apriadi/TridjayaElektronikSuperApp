# TE SuperApp Backend

Backend API untuk Tridjaya Elektronik SuperApp, dibangun dengan Rust menggunakan Axum framework.

## Fitur

- **Authentication**: JWT-based login/logout dengan refresh token
- **Role-based Access**: 5 role pengguna (Owner, Kepala Cabang, Admin, Sales, Driver)
- **Password Reset**: OTP-based password reset
- **Database**: SQLite dengan SQLx

## Teknologi

- **Framework**: Axum (Web framework)
- **Database**: SQLite dengan SQLx (async SQL toolkit)
- **Auth**: JWT (JSON Web Tokens)
- **Password**: bcrypt untuk hashing
- **Serialization**: Serde + Serde JSON

## Struktur Folder

```
backend/
├── src/
│   ├── main.rs           # Entry point & route definitions
│   ├── config.rs         # Environment configuration
│   ├── error.rs          # Error handling types
│   ├── models.rs         # Data models (User, Branch, etc)
│   ├── db.rs             # Database initialization & migrations
│   ├── utils.rs          # Helper functions (JWT, password, OTP)
│   ├── middleware.rs     # Auth middleware
│   └── handlers/
│       └── auth.rs       # Auth route handlers
├── Cargo.toml
├── .env.example
└── README.md
```

## Cara Menjalankan

### 1. Install Dependencies

Pastikan Anda sudah menginstall:
- [Rust](https://rustup.rs/) (versi terbaru)
- SQLite3

### 2. Setup Environment

```bash
cd backend
cp .env.example .env
```

Edit file `.env` sesuai kebutuhan.

### 3. Build & Run

```bash
# Development mode
cargo run

# Release mode
cargo run --release
```

Server akan berjalan di `http://0.0.0.0:8080`

## API Endpoints

### Authentication

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/login` | Login dengan username & password |
| POST | `/api/auth/logout` | Logout dan revoke refresh token |
| POST | `/api/auth/refresh` | Refresh access token |
| POST | `/api/auth/password-reset/request` | Request OTP reset password |
| POST | `/api/auth/password-reset/verify` | Verifikasi OTP & reset password |

### User Default (Seed Data)

Saat pertama kali dijalankan, sistem akan membuat user default:

| Username | Password | Role | Cabang |
|----------|----------|------|--------|
| owner | 123456 | Owner | - |
| kepala_cabang | 123456 | Kepala Cabang | Cabang Bandung |
| admin | 123456 | Admin | Kantor Pusat |
| sales1 | 123456 | Sales | Cabang Bandung |
| sales2 | 123456 | Sales | Kantor Pusat |
| driver1 | 123456 | Driver | Cabang Bandung |
| driver2 | 123456 | Driver | Kantor Pusat |

### Login Request Example

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "owner", "password": "123456"}'
```

**Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### JWT Token Structure

Access token payload:
```json
{
  "sub": "user-id",
  "username": "owner",
  "role": "Owner",
  "branch_id": "branch-uuid",
  "branch_name": "Kantor Pusat",
  "exp": 1699999999,
  "iat": 1699999999
}
```

## Mobile App Integration

Base URL untuk mobile app:
- Android Emulator: `http://10.0.2.2:8080/api`
- iOS Simulator: `http://localhost:8080/api`
- Device fisik: `http://<your-ip>:8080/api`

Update file `.env` di mobile app:
```
API_BASE_URL=http://10.0.2.2:8080/api
```

## Development Notes

### Menambahkan User Baru

Untuk sementara, user baru dapat ditambahkan dengan mengubah fungsi `seed_data` di `src/db.rs`.

### Mengubah JWT Secret

**PENTING**: Ganti `JWT_SECRET` di production! Jika secret diubah, semua token yang ada akan invalid.

### Database Migration

Untuk reset database:
```bash
# Hapus database file
rm te_superapp.db

# Jalankan ulang (auto-migrate)
cargo run
```

## Troubleshooting

### Port sudah digunakan

Ubah `PORT` di file `.env` ke port lain, contoh: `PORT=3000`

### SQLite permission error

Pastikan direktori backend memiliki permission write:
```bash
chmod +w .
```

### Build error

Update dependencies:
```bash
cargo update
cargo clean
cargo build
```
