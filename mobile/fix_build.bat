@echo off
echo Cleaning Flutter build cache...
cd /d "%~dp0"

:: Clean Flutter
call flutter clean

:: Get dependencies
call flutter pub get

:: Build debug APK
call flutter build apk --debug

echo.
echo Build complete!
if %ERRORLEVEL% == 0 (
    echo ✅ Build successful!
) else (
    echo ❌ Build failed with error code %ERRORLEVEL%
)
pause
