#!/bin/bash

# Name of the output file
PROJECT_NAME="Material-Clock"
OUTPUT_FILE="../$PROJECT_NAME.plasmoid"

# Navigate to package directory
cd package || { echo "Directory 'package' not found"; exit 1; }

# Remove old package if it exists
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
fi

echo "Packaging $PROJECT_NAME..."

# Try using zip if available
if command -v zip &> /dev/null; then
    zip -r "$OUTPUT_FILE" . -x "*.git*"
    status=$?
else
    # Fallback to Python 3 if zip is not available
    echo "zip command not found, falling back to Python..."
    python3 -c "import shutil, os; shutil.make_archive('../${PROJECT_NAME}', 'zip', '.'); os.rename('../${PROJECT_NAME}.zip', '${OUTPUT_FILE}')"
    status=$?
fi

if [ $status -eq 0 ]; then
    echo "Successfully created $PROJECT_NAME.plasmoid in the root directory."
else
    echo "Failed to create package."
    exit 1
fi
