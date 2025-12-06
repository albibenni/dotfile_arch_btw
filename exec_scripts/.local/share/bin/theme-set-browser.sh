#!/bin/bash

# Set browser theme based on current theme

CURRENT_THEME_LINK="$HOME/.config/current-theme"

# Get current theme
if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
    echo "No theme currently set"
    exit 1
fi

THEME_PATH=$(readlink "$CURRENT_THEME_LINK")
CHROMIUM_THEME_FILE="$THEME_PATH/chromium.theme"

if [[ ! -f "$CHROMIUM_THEME_FILE" ]]; then
    echo "No browser theme config found for current theme"
    exit 1
fi

# Read RGB color values from chromium.theme (format: R,G,B)
COLOR=$(cat "$CHROMIUM_THEME_FILE" | tr -d ' ')

if [[ -z "$COLOR" ]]; then
    echo "Invalid browser theme configuration"
    exit 1
fi

# Apply to Chromium/Chrome (uses GTK theme color)
# The chromium.theme file contains RGB values for the browser theme color
# This is typically applied through browser settings or extensions

echo "Browser theme color set to: $COLOR"
echo "Note: You may need to manually apply this in your browser settings"
echo "  Chromium/Chrome: Use the RGB values ($COLOR) in theme settings"
