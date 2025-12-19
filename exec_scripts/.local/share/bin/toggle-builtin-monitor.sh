#!/bin/bash

# Check if built-in monitor is currently enabled
BUILTIN_STATUS=$(hyprctl monitors | grep -A 20 "Samsung Display Corp. 0x41A0" | grep "disabled:" | grep -c "false")

if [ "$BUILTIN_STATUS" -eq 1 ]; then
    # Monitor is enabled, disable it
    hyprctl keyword monitor "desc:Samsung Display Corp. 0x41A0,disable"
    notify-send "Monitor" "Built-in display disabled" -t 2000
else
    # Monitor is disabled, enable it
    hyprctl keyword monitor "desc:Samsung Display Corp. 0x41A0,1920x1200@60,auto,1.0"
    notify-send "Monitor" "Built-in display enabled" -t 2000
fi
