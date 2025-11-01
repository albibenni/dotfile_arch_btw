#!/bin/bash

# --- CONFIGURATION ---
DISPLAY_NUM=2
STEP=5
STATE_FILE="/tmp/waybar_brightness_d2.tmp"
# ---------------------

# Function to send the actual DDC/CI command in the background
set_brightness_in_background() {
    pkill -f "ddcutil.*setvcp 10"
    (ddcutil --display $DISPLAY_NUM setvcp 10 $1 2>/dev/null) &
}

if [ ! -f "$STATE_FILE" ]; then
    initial_brightness=$(ddcutil --display $DISPLAY_NUM getvcp 10 -t 2>&1 | grep "^VCP" | cut -d ' ' -f 4)
    echo "$initial_brightness" > "$STATE_FILE"
fi

current=$(cat "$STATE_FILE")

case "$1" in
    "get")
        echo " $current"
        ;;
    "up")
        new_brightness=$((current + STEP > 100 ? 100 : current + STEP))
        if [ "$current" -ne "$new_brightness" ]; then
            echo "$new_brightness" > "$STATE_FILE"
            set_brightness_in_background "$new_brightness"
        fi
        pkill -RTMIN+8 waybar # Can add whatever RTMIN+n you please, as long as it's an integer. Make sure the signals match between the config and script.
        ;;
    "down")
        new_brightness=$((current - STEP < 0 ? 0 : current - STEP))
        if [ "$current" -ne "$new_brightness" ]; then
            echo "$new_brightness" > "$STATE_FILE"
            set_brightness_in_background "$new_brightness"
        fi
        pkill -RTMIN+8 waybar
        ;;
    "right_click")
	new_brightness=0
	if [ "$current" -ne "$new_brightness" ]; then
            echo "$new_brightness" > "$STATE_FILE"
            set_brightness_in_background "$new_brightness"
        fi
        pkill -RTMIN+8 waybar
        ;;
    "left_click")
	new_brightness=100
     	if [ "$current" -ne "$new_brightness" ]; then
            echo "$new_brightness" > "$STATE_FILE"
            set_brightness_in_background "$new_brightness"
        fi
        pkill -RTMIN+8 waybar
        ;;
esac
