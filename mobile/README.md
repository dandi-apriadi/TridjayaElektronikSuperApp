# TE SuperApp — Mobile (Flutter)

Aplikasi mobile ERP Tridjaya Elektronik untuk Android & iOS.

## Setup

### Prasyarat
- Flutter SDK >= 3.19.0 (https://docs.flutter.dev/get-started/install/windows/mobile)
- Android Studio + Android SDK
- Dart >= 3.3.0

### Instalasi

```bash
# Masuk ke folder mobile
cd mobile

# Install dependencies
flutter pub get

# Generate kode (Freezed, Riverpod, Drift)
dart run build_runner build --delete-conflicting-outputs

# Jalankan di emulator/device
flutter run
```

### Konfigurasi Environment

Edit `.env` untuk menyesuaikan URL backend:
```
API_BASE_URL=http://10.0.2.2:8080/api   # Android emulator → localhost
# API_BASE_URL=http://localhost:8080/api  # iOS simulator
```

## Struktur Project

```
lib/
├── core/
│   ├── constants/       # App constants, API endpoints
│   ├── models/          # Shared models (UserModel, UserRole)
│   ├── network/         # Dio client + interceptors
│   ├── router/          # GoRouter + role-based routing
│   └── theme/           # AppTheme, AppColors, AppTextStyles
├── features/
│   ├── auth/            # Login, Password Reset
│   ├── owner/           # Dashboard Owner
│   ├── kepala_cabang/   # Dashboard Kepala Cabang
│   ├── admin/           # Dashboard Admin + Inventori
│   ├── sales/           # Dashboard Sales + CRM
│   └── driver/          # Dashboard Driver + Delivery
└── shared/
    ├── dummy_data/      # Data dummy untuk Phase A
    └── widgets/         # Shared widgets (StatCard, StatusBadge, dll)
```

## Fase Development

| Fase | Status | Keterangan |
|------|--------|------------|
| Phase A | 🟡 In Progress | Flutter UI dengan dummy data + Auth API |
| Phase B | ⏳ Menunggu | Backend Rust API (setelah approval UI) |

## Role & Dashboard

| Role | Warna | Fitur Utama |
|------|-------|-------------|
| Owner | Ungu | Semua cabang, ranking performa |
| Kepala Cabang | Biru | Dashboard cabang, approval laporan |
| Admin | Teal | Inventori, stock input |
| Sales | Oranye | CRM, prospek, kampanye WA |
| Driver | Abu-abu | Jadwal pengiriman, navigasi |
