@echo off
REM Quick icon setup script for ExpenseTrack (Windows)

echo.
echo 🎨 ExpenseTrack Icon Setup
echo ==========================
echo.

cd final_project_mobile_app

REM Get dependencies
echo 📦 Installing flutter_launcher_icons...
call flutter pub get

REM Check if icon exists
if not exist "assets\app_icon\icon.png" (
    echo.
    echo ⚠️  Icon file not found at: assets\app_icon\icon.png
    echo.
    echo Please follow these steps:
    echo 1. Visit: https://www.appicon.co/
    echo 2. Upload the SVG file from project root (app_icon.svg^)
    echo 3. Download the generated icon.png
    echo 4. Save it to: assets\app_icon\icon.png
    echo 5. Run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo ✨ Generating platform-specific icons...
call flutter pub run flutter_launcher_icons

echo.
echo ✅ Icon generation complete!
echo.
echo Next steps:
echo 1. Run: flutter clean
echo 2. Run: flutter pub get
echo 3. Run: flutter run
echo.
echo The new app icon will be visible on all platforms!
echo.
pause
