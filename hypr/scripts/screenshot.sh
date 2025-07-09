#!/bin/bash

# grimblast freeze screenshot to satty
# Usage: ./screenshot.sh [area|screen|window]

# Set default mode to area if no argument provided
MODE=${1:-area}

# Create temp file for the screenshot
TEMP_FILE=$(mktemp --suffix=.png)

# Take screenshot with freeze and save to temp file
grimblast --freeze copysave "$MODE" "$TEMP_FILE"

# Check if screenshot was successful
if [ $? -eq 0 ] && [ -f "$TEMP_FILE" ]; then
    # Open in satty for editing
    satty --filename "$TEMP_FILE" --output-filename "$TEMP_FILE" --copy-command "wl-copy"
    
    # Clean up
    rm "$TEMP_FILE"
else
    echo "Screenshot failed!"
    exit 1
fi
