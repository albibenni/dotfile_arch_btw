#!/bin/bash

# --- CONFIGURATION ---
MIN_TEMP=2000  # Warmest (most nightlight)
MAX_TEMP=6500  # Coolest (most daylight)
STEP=500       # Temperature step for scrolling
STATE_FILE="/tmp/waybar_nightlight.tmp"
# ---------------------

# Ensure hyprsunset is running
ensure_hyprsunset() {
    if ! pgrep -x hyprsunset > /dev/null; then
        setsid uwsm-app -- hyprsunset &
    fi

    # Wait for socket to be created (even if already running, to be safe)
    local timeout=20
    local count=0
    local runtime_dir="/run/user/$(id -u)/hypr"
    
    # If SIGNATURE is missing, try to find the latest directory
    local sig=$HYPRLAND_INSTANCE_SIGNATURE
    if [ -z "$sig" ]; then
        sig=$(ls -t "$runtime_dir" 2>/dev/null | head -n 1)
    fi
    
    local socket_path="$runtime_dir/$sig/.hyprsunset.sock"
    
    while [ ! -S "$socket_path" ] && [ $count -lt $timeout ]; do
        sleep 0.1
        ((count++))
    done
}

# Set temperature and update state file
set_temperature() {
    local temp=$1
    ensure_hyprsunset
    hyprctl hyprsunset temperature "$temp" 2>/dev/null
    echo "$temp" > "$STATE_FILE"
}

# Get current temperature
get_current_temp() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        # Initialize from hyprsunset or use default
        if pgrep -x hyprsunset > /dev/null; then
            current=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')
            if [ -n "$current" ]; then
                echo "$current" > "$STATE_FILE"
                echo "$current"
            else
                echo "5000" > "$STATE_FILE"
                echo "5000"
            fi
        else
            echo "5000" > "$STATE_FILE"
            echo "5000"
        fi
    fi
}

# Display with icon
display_with_icon() {
    local temp=$1
    if [ "$temp" -le 3500 ]; then
        echo " ${temp}K"  # Nightlight icon for warm temps
    else
        echo " ${temp}K"  # Daylight icon for cool temps
    fi
}

current=$(get_current_temp)

case "$1" in
    "get")
        display_with_icon "$current"
        ;;
    "up")
        # Increase temperature (more daylight, less warm)
        new_temp=$((current + STEP > MAX_TEMP ? MAX_TEMP : current + STEP))
        if [ "$current" -ne "$new_temp" ]; then
            set_temperature "$new_temp"
        fi
        pkill -RTMIN+9 waybar
        ;;
    "down")
        # Decrease temperature (more nightlight, warmer)
        new_temp=$((current - STEP < MIN_TEMP ? MIN_TEMP : current - STEP))
        if [ "$current" -ne "$new_temp" ]; then
            set_temperature "$new_temp"
        fi
        pkill -RTMIN+9 waybar
        ;;
    "toggle")
        # Toggle between preset warm (3000K) and neutral (5000K)
        if [ "$current" -le 3500 ]; then
            set_temperature 5000
            notify-send "   Daylight screen temperature"
        else
            set_temperature 3000
            notify-send "  Nightlight screen temperature"
        fi
        pkill -RTMIN+9 waybar
        ;;
esac
