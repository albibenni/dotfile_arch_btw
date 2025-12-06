#!/bin/bash

# Set cursor theme based on current theme
# Note: Cursor theme is typically handled by hyprland config
# This script is a placeholder for future cursor theme support

CURRENT_THEME_LINK="$HOME/.config/current-theme"

# Get current theme
if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
    echo "No theme currently set"
    exit 1
fi

THEME_PATH=$(readlink "$CURRENT_THEME_LINK")
THEME_NAME=$(basename "$THEME_PATH")

# Cursor themes are typically set in hyprland.conf via:
# exec-once = hyprctl setcursor <theme-name> <size>
# The cursor theme is usually part of the hyprland.conf in each theme

# For now, just reload hyprland which will apply cursor from theme's hyprland.conf
if command -v hyprctl &>/dev/null; then
    hyprctl reload 2>/dev/null
    echo "Cursor theme reloaded with Hyprland config"
else
    echo "Cursor theme is handled by Hyprland config"
fi
