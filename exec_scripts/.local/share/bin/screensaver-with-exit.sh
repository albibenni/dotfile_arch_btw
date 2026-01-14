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
screensaver_in_focus() {
    hyprctl activewindow -j | jq -e '.class == "org.albibenni.screensaver"' >/dev/null 2>&1
}

exit_screensaver() {
    hyprctl keyword cursor:invisible false &>/dev/null || true
    pkill -x tte 2>/dev/null
    pkill -f org.albibenni.screensaver 2>/dev/null
    exit 0
}

# Exit the screensaver on signals and input from keyboard and mouse
trap exit_screensaver SIGINT SIGTERM SIGHUP SIGQUIT
hyprctl keyword cursor:invisible true &>/dev/null
tty=$(tty 2>/dev/null)

# Run tte in a loop in background
while true; do
    # Pick a random logo
    random_logo="${logos[$RANDOM % ${#logos[@]}]}"

    tte -i "$random_logo" \
        --frame-rate 120 --canvas-width 0 --canvas-height 0 --reuse-canvas --anchor-canvas c --anchor-text c --random-effect --exclude-effects dev_worm \
        --no-eol --no-restore-cursor &
    while pgrep -t "${tty#/dev/}" -x tte >/dev/null; do
        if read -n1 -t 1 || ! screensaver_in_focus; then
            exit_screensaver
        fi
    done
done

# loop_pid=$!
#
# # Wait for any keypress
# read -n 1 -s
#
# # Kill the loop when key is pressed
# kill $loop_pid 2>/dev/null
# pkill -P $loop_pid 2>/dev/null
