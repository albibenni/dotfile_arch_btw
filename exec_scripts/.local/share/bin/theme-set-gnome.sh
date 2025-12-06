#!/bin/bash

# Set GNOME/GTK theme based on current theme

CURRENT_THEME_LINK="$HOME/.config/current-theme"

# Get current theme
if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
    echo "No theme currently set"
    exit 1
fi

THEME_PATH=$(readlink "$CURRENT_THEME_LINK")
ICONS_THEME_FILE="$THEME_PATH/icons.theme"

if [[ ! -f "$ICONS_THEME_FILE" ]]; then
    echo "No GNOME/GTK theme config found for current theme"
    exit 1
fi

# Read icon theme name
ICON_THEME=$(cat "$ICONS_THEME_FILE" | tr -d ' \n')

if [[ -z "$ICON_THEME" ]]; then
    echo "Invalid GNOME theme configuration"
    exit 1
fi

# Set icon theme using gsettings (for GTK apps)
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME" 2>/dev/null
    echo "GTK icon theme set to: $ICON_THEME"
else
    echo "gsettings not found, skipping GTK icon theme"
fi

# Note: xdg-settings doesn't support icon-theme, so we skip that part
