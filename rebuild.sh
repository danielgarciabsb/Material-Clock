#!/bin/bash

PROJECT_NAME="Material-Clock"
PLASMOID_FILE="${PROJECT_NAME}.plasmoid"
INSTALL_DIR="$HOME/.local/share/kpackage/generic/material.clock"

echo "🚧 Building $PROJECT_NAME..."

# Ensure we are in the project root
if [ ! -d "package" ]; then
    echo "❌ Error: 'package' directory not found. Please run this from the project root."
    exit 1
fi

# Create the package
rm -f "$PLASMOID_FILE"
cd package
zip -r "../$PLASMOID_FILE" . -x "*.git*"
cd ..

if [ ! -f "$PLASMOID_FILE" ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build successful: $PLASMOID_FILE"

echo "🔄 Reinstalling..."
# Using kpackagetool6 to upgrade if exists, or install
# Note: 'upgrade' sometimes fails if structure changed, so we can clean install
kpackagetool6 --upgrade "$PLASMOID_FILE" || (kpackagetool6 -r material.clock; kpackagetool6 -i "$PLASMOID_FILE")

echo "✅ Installed successfully."

echo ""
echo "---------------------------------------------------------"
echo "⚠️  IMPORTANT: Plasma caches files aggressively."
echo "To see changes immediately, try ONE of the following:"
echo ""
echo "1. Run specific viewer (Recommended for testing):"
echo "   plasmoidviewer -a package"
echo ""
echo "2. Restart Plasma Shell (Resets your desktop):"
echo "   kquitapp5 plasmashell || kquitapp6 plasmashell"
echo "   kstart5 plasmashell || kstart6 plasmashell"
echo "---------------------------------------------------------"
