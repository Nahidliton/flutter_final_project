#!/usr/bin/env python3
"""
ExpenseTrack Icon Generator
Generates app icons from SVG or PNG source
"""

import os
import sys
from pathlib import Path

def generate_from_svg():
    """
    Generate PNG from SVG using available tools
    """
    try:
        from cairosvg import svg2png
        
        svg_path = Path("app_icon.svg")
        icon_path = Path("final_project_mobile_app/assets/app_icon")
        icon_path.mkdir(parents=True, exist_ok=True)
        
        output = icon_path / "icon.png"
        
        print(f"📐 Generating PNG from SVG...")
        svg2png(url=str(svg_path), write_to=str(output), output_width=1024, output_height=1024)
        print(f"✅ Icon generated: {output}")
        return True
        
    except ImportError:
        print("⚠️  cairosvg not installed")
        print("Install with: pip install cairosvg")
        return False

def generate_from_existing_svg():
    """
    Use Imagemagick if available
    """
    try:
        import subprocess
        result = subprocess.run(
            ["convert", "-background", "transparent", "-density", "300", 
             "app_icon.svg", "-resize", "1024x1024", 
             "final_project_mobile_app/assets/app_icon/icon.png"],
            check=True,
            capture_output=True
        )
        print("✅ Icon generated with ImageMagick")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def main():
    print("🎨 ExpenseTrack Icon Generator")
    print("=" * 40)
    print()
    
    # Check if SVG exists
    if not Path("app_icon.svg").exists():
        print("❌ app_icon.svg not found in project root")
        print("Please create the icon manually using:")
        print("   1. https://www.appicon.co/")
        print("   2. Save as: final_project_mobile_app/assets/app_icon/icon.png")
        sys.exit(1)
    
    print("📍 Found: app_icon.svg")
    print()
    
    # Try cairosvg first
    if generate_from_svg():
        print()
        print("🚀 Next steps:")
        print("   1. cd final_project_mobile_app")
        print("   2. flutter pub run flutter_launcher_icons")
        print("   3. flutter run")
        sys.exit(0)
    
    # Try ImageMagick
    if generate_from_existing_svg():
        print()
        print("🚀 Next steps:")
        print("   1. cd final_project_mobile_app")
        print("   2. flutter pub run flutter_launcher_icons")
        print("   3. flutter run")
        sys.exit(0)
    
    # If both fail, provide manual instructions
    print("❌ Could not generate icon automatically")
    print()
    print("📦 Install one of these:")
    print("   pip install cairosvg")
    print("   # OR")
    print("   apt-get install imagemagick  # Linux")
    print("   brew install imagemagick     # macOS")
    print()
    print("🌐 Or use the online tool:")
    print("   https://www.appicon.co/")
    print()
    print("Save the PNG as: final_project_mobile_app/assets/app_icon/icon.png")

if __name__ == "__main__":
    main()
