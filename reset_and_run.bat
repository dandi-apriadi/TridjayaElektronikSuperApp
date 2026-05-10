@echo off
echo ==========================================
echo RESET DATABASE & RESTART SERVER
echo ==========================================

cd /d "c:\Users\acer\Desktop\Project\RUST\TE SuperApp\backend"

:: Kill any running server processes
taskkill /F /IM te-superapp-backend.exe 2>nul
taskkill /F /IM te_superapp_backend.exe 2>nul

:: Wait a moment
timeout /t 2 /nobreak >nul

:: Delete old database files
echo Deleting old database...
del /F te_superapp.db 2>nul
del /F te_superapp.db-shm 2>nul
del /F te_superapp.db-wal 2>nul

:: Clean and rebuild
echo Cleaning build cache...
cargo clean

echo Building server...
cargo build --release

:: Run server with visible output
echo.
echo ==========================================
echo Starting server... Press Ctrl+C to stop
echo ==========================================
.\target\release\te-superapp-backend.exe

pause
