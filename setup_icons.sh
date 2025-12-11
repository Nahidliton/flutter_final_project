#!/bin/bash
# Quick icon setup script for ExpenseTrack

echo "🎨 ExpenseTrack Icon Setup"
echo "=========================="

cd "$(dirname "$0")/final_project_mobile_app"

# Get dependencies
echo "📦 Installing flutter_launcher_icons..."
flutter pub get

# Check if icon exists
if [ ! -f "assets/app_icon/icon.png" ]; then
    echo ""
    echo "⚠️  Icon file not found at: assets/app_icon/icon.png"
    echo ""
    echo "Please follow these steps:"
    echo "1. Visit: https://www.appicon.co/"
    echo "2. Upload the SVG file from project root (app_icon.svg)"
    echo "3. Download the generated icon.png"
    echo "4. Save it to: assets/app_icon/icon.png"
    echo "5. Run this script again"
    exit 1
fi

echo "✨ Generating platform-specific icons..."
flutter pub run flutter_launcher_icons

echo ""
echo "✅ Icon generation complete!"
echo ""
echo "Next steps:"
echo "1. Run: flutter clean"
echo "2. Run: flutter pub get"
echo "3. Run: flutter run"
echo ""
echo "The new app icon will be visible on all platforms!"
