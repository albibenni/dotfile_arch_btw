#!/bin/bash

# Temperature values (should match toggle-nightlight.sh)
ON_TEMP=3000
OFF_TEMP=5000

# Check if hyprsunset is running
if ! pgrep -x hyprsunset > /dev/null; then
    echo " ${OFF_TEMP}K"  # Daylight icon with default temp when not running
    exit 0
fi

# Query the current temperature
CURRENT_TEMP=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')

# Display icon and temperature based on current temperature
if [[ "$CURRENT_TEMP" == "$ON_TEMP" ]]; then
    echo " ${CURRENT_TEMP}K"  # Nightlight icon with temperature
else
    echo " ${CURRENT_TEMP}K"  # Daylight icon with temperature
fi
