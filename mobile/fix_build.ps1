# Script untuk memperbaiki Flutter build error
# Jalankan di PowerShell: .\fix_build.ps1

Write-Host "🔧 Memperbaiki Flutter Build Error..." -ForegroundColor Cyan

# Step 1: Clean Flutter
Write-Host "`n📦 Step 1: Flutter clean..." -ForegroundColor Yellow
flutter clean

# Step 2: Hapus folder build Android
Write-Host "`n📦 Step 2: Hapus Android build..." -ForegroundColor Yellow
if (Test-Path "android\app\build") {
    Remove-Item -Recurse -Force "android\app\build"
    Write-Host "✅ Android build dihapus" -ForegroundColor Green
}

# Step 3: Hapus .dart_tool
Write-Host "`n📦 Step 3: Hapus .dart_tool..." -ForegroundColor Yellow
if (Test-Path ".dart_tool") {
    Remove-Item -Recurse -Force ".dart_tool"
    Write-Host "✅ .dart_tool dihapus" -ForegroundColor Green
}

# Step 4: Hapus pubspec.lock
Write-Host "`n📦 Step 4: Hapus pubspec.lock..." -ForegroundColor Yellow
if (Test-Path "pubspec.lock") {
    Remove-Item "pubspec.lock"
    Write-Host "✅ pubspec.lock dihapus" -ForegroundColor Green
}

# Step 5: Get dependencies
Write-Host "`n📦 Step 5: Get dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 6: Build
Write-Host "`n📦 Step 6: Build APK..." -ForegroundColor Yellow
flutter build apk --debug

Write-Host "`n✅ Selesai!" -ForegroundColor Green
