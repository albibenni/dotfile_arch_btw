#!/bin/bash

# Check and create logos if they don't exist
[[ ! -f "$HOME/.local/share/arch/logo.txt" ]] && bash "$HOME/dotfiles/script_install/look-and-feel/logo.sh"
[[ ! -f "$HOME/.local/share/arch/logo1.txt" ]] && bash "$HOME/dotfiles/script_install/look-and-feel/logo1.sh"
[[ ! -f "$HOME/.local/share/arch/logo2.txt" ]] && bash "$HOME/dotfiles/script_install/look-and-feel/logo2.sh"
[[ ! -f "$HOME/.local/share/arch/logo3.txt" ]] && bash "$HOME/dotfiles/script_install/look-and-feel/logo3.sh"

# Array of available logos
logos=(
  "$HOME/.local/share/arch/logo.txt"
  "$HOME/.local/share/arch/logo1.txt"
  "$HOME/.local/share/arch/logo2.txt"
  "$HOME/.local/share/arch/logo3.txt"
)

# Run tte in a loop in background
(
  while true; do
    # Pick a random logo
    random_logo="${logos[$RANDOM % ${#logos[@]}]}"

    clear
    tte --input-file "$random_logo" \
        --canvas-width 0 \
        --canvas-height 0 \
        --anchor-canvas c \
        --anchor-text c \
        --random-effect
    sleep 1
  done
) &

loop_pid=$!

# Wait for any keypress
read -n 1 -s

# Kill the loop when key is pressed
kill $loop_pid 2>/dev/null
pkill -P $loop_pid 2>/dev/null
