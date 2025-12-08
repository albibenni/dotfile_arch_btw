#!/bin/bash

# Fix Waybar brightness state files by reinitializing them
# This script reinitializes corrupted or empty brightness state files

STATE_FILES=(
    "/tmp/waybar_brightness_d1.tmp"
    "/tmp/waybar_brightness_d2.tmp"
)

SCRIPTS=(
    "$HOME/.config/waybar/brightness-control.sh"
    "$HOME/.config/waybar/brightness-control-m2.sh"
)

echo "Fixing Waybar brightness state files..."

# Remove corrupted state files
for state_file in "${STATE_FILES[@]}"; do
    if [ -f "$state_file" ]; then
        size=$(stat -c%s "$state_file" 2>/dev/null || echo "0")
        if [ "$size" -le 1 ]; then
            echo "Removing corrupted state file: $state_file"
            rm -f "$state_file"
        fi
    fi
done

# Reinitialize by calling each script
for script in "${SCRIPTS[@]}"; do
    if [ -x "$script" ]; then
        echo "Reinitializing $(basename "$script")..."
        "$script" get > /dev/null 2>&1 &
    fi
done

# Wait for background initialization
sleep 2

# Reload Waybar
echo "Reloading Waybar..."
pkill -RTMIN+8 waybar

echo "Done! Brightness modules should now be visible."
