---
description: Setup dan menjalankan terminal untuk backend + mobile USB debugging
---

# Terminal Setup & Development Workflow

Panduan untuk menjalankan backend Rust dan Flutter mobile dengan USB debugging.

## Struktur Terminal yang Dibutuhkan

### Terminal 1: Backend Server (Rust)
```powershell
# Navigate ke backend
cd "c:\Users\acer\Desktop\Project\RUST\TE SuperApp\backend"

# Setup environment (pertama kali saja)
copy .env.example .env

# Install dependencies & build (pertama kali saja)
cargo build

# Jalankan server
cargo run
```

Server akan start di `http://localhost:8080`

### Terminal 2: Check Backend Health
```powershell
# Test login endpoint
curl -X POST http://localhost:8080/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"username": "owner", "password": "123456"}'
```

### Terminal 3: Flutter Mobile (Android USB Debug)
```powershell
# Navigate ke mobile
cd "c:\Users\acer\Desktop\Project\RUST\TE SuperApp\mobile"

# Check devices yang terhubung
flutter devices

# Install dependencies (pertama kali saja)
flutter pub get

# Jalankan dengan USB debug
flutter run --debug

# Atau dengan verbose untuk debugging
flutter run --verbose
```

### Terminal 4: Flutter Build/Logs
```powershell
cd "c:\Users\acer\Desktop\Project\RUST\TE SuperApp\mobile"

# Check logs real-time
flutter logs

# Hot restart saat development (tekan di terminal 3)
# r - hot reload
# R - hot restart
# q - quit
```

## Setup USB Debugging Android

### 1. Enable Developer Options di HP
1. Buka **Settings** → **About Phone**
2. Tap **Build Number** 7x sampai muncul "You are now a developer!"
3. Kembali ke Settings → **System** → **Developer Options**

### 2. Enable USB Debugging
1. Di Developer Options, aktifkan **USB Debugging**
2. Hubungkan HP ke PC via USB
3. Pilih mode **File Transfer (MTP)** di notifikasi HP
4. Accept dialog "Allow USB debugging?" di HP

### 3. Verify Connection
```powershell
# Di Terminal 4
flutter devices

# Output contoh:
# SM A525F (mobile) • RZ8R80... • android-arm64 • Android 14 (API 34)
```

## Setup Backend Environment

### File .env (backend\.env)
```env
PORT=8080
DATABASE_URL=sqlite://te_superapp.db
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRY_HOURS=24
REFRESH_TOKEN_EXPIRY_DAYS=7
```

### Update Mobile API URL

File: `mobile\.env`
```
# Untuk Android Emulator
API_BASE_URL=http://10.0.2.2:8080/api

# Untuk USB Debug (HP fisik) - ganti dengan IP PC
# API_BASE_URL=http://192.168.1.100:8080/api
```

**Cek IP PC:**
```powershell
ipconfig
# Cari "IPv4 Address" di Wi-Fi adapter
```

## Command Cheat Sheet

### Backend Commands
```powershell
cd backend
cargo run              # Jalankan server
cargo check            # Check tanpa build
cargo build --release  # Build production
```

### Mobile Commands
```powershell
cd mobile
flutter pub get        # Install dependencies
flutter run            # Run debug mode
flutter run --release  # Run release mode
flutter clean          # Clean build cache
flutter doctor         # Check setup
```

### Network Test
```powershell
# Test backend dari PC
curl http://localhost:8080/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"username":"owner","password":"123456"}'

# Test dari HP (gunakan browser atau Postman app)
# Akses: http://<IP-PC>:8080/api/auth/login
```

## Troubleshooting

### Issue: "Connection refused" di HP
- Pastikan PC dan HP di **WiFi yang sama**
- Cek firewall Windows (allow port 8080)
- Ganti `localhost` ke IP PC di mobile .env

### Issue: Backend tidak mau build
```powershell
cd backend
cargo clean
cargo update
cargo run
```

### Issue: Flutter dependencies error
```powershell
cd mobile
flutter clean
flutter pub cache clean
flutter pub get
```

### Issue: USB device tidak terdeteksi
1. Install **Google USB Driver** via Android SDK Manager
2. Cek device manager - install driver manual jika ada yellow mark
3. Coba USB port lain
4. Restart ADB:
   ```powershell
   adb kill-server
   adb start-server
   adb devices
   ```

### Issue: Hot reload tidak jalan
- Pastikan tidak ada compile error (cek Terminal 3)
- Save file .dart terlebih dahulu
- Tekan `r` di terminal running app

## Run Order (Step by Step)

1. **Start Terminal 1** (Backend): `cargo run`
2. **Wait** sampai muncul "Server listening on http://0.0.0.0:8080"
3. **Start Terminal 3** (Mobile): `flutter run --debug`
4. **Verify** app berjalan di HP
5. **Test login** dengan user default

## Port yang Digunakan

| Service | Port | Description |
|---------|------|-------------|
| Backend API | 8080 | Rust Axum server |
| Flutter debug | 8100-8200 | Hot reload websocket |

## User Test Login

| Role | Username | Password |
|------|----------|----------|
| Owner | owner | 123456 |
| Kepala Cabang | kepala_cabang | 123456 |
| Admin | admin | 123456 |
| Sales | sales1 | 123456 |
| Driver | driver1 | 123456 |

## Useful VS Code Shortcuts

- `Ctrl+Shift+P` → "Flutter: Open DevTools"
- `Ctrl+F5` → Run without debugging
- `F5` → Start debugging

## Catatan Penting

- Backend harus selalu jalan duluan sebelum mobile app
- Gunakan IP PC (bukan localhost) saat USB debug HP fisik
- Database SQLite tersimpan di `backend/te_superapp.db`
- Reset data = hapus file .db dan restart backend
