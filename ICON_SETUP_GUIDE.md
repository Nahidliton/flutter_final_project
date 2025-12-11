# ExpenseTrack App Icon Setup Guide

## Option 1: Using Online Icon Generator (Recommended - Fastest)

1. Go to: https://www.appicon.co/
2. Upload the SVG file located at: `app_icon.svg` in the project root
3. Download the generated icons
4. Extract and place icons in the respective directories:
   - Android: `android/app/src/main/res/mipmap-*/`
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
   - Web: `web/icons/`

## Option 2: Using Flutter Launcher Icons Package (Easiest)

1. Save a 1024x1024 PNG icon to: `assets/app_icon/icon.png`
   - Use the SVG provided or create your own

2. Run the icon generator:
   ```bash
   cd final_project_mobile_app
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

3. This will automatically:
   - Generate all Android icon sizes (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
   - Generate all iOS icon sizes
   - Generate web icons
   - Update configurations

## Icon Design Specifications

**App Icon (1024x1024px)**
- Design: Wallet with coin and "$" symbol on gradient background (#6366F1 to #8B5CF6)
- Style: Modern, minimal, professional
- Safe area: Keep important elements within center 960x960px
- Corners: Should be rounded (for iOS)

## What Gets Updated

- ✅ Android launcher icons (all sizes)
- ✅ iOS app icons (all sizes)  
- ✅ Web icons (192px, 512px, maskable)
- ✅ macOS app icon
- ✅ Windows app icon
- ✅ App name changed to "ExpenseTrack"

## Current Icon Colors

Primary Gradient:
- Start: #6366F1 (Indigo)
- End: #8B5CF6 (Purple)

Accent:
- White
- Gold/Yellow (#FFD700, #FFA500)

## After Icon Generation

1. Restart the app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. The new app icon will appear on:
   - Home screen
   - App drawer
   - Settings
   - All platforms (Android, iOS, Web, Windows, macOS)

## Quick Steps to Complete Icon Update

1. Create a 1024x1024px PNG icon based on the provided SVG
2. Place it in `assets/app_icon/icon.png`
3. Run: `flutter pub run flutter_launcher_icons`
4. Done! All icons are generated automatically
