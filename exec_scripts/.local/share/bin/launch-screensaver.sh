#!/bin/bash

# Exit early if we don't have the tte show
if ! command -v tte &>/dev/null; then
    exit 1
fi

# Use Arch Linux logo for screensaver
screensaver_file="$HOME/.local/share/arch/logo.txt"

if [[ ! -f "$screensaver_file" ]]; then
    echo "Arch logo not found. Run the logo.sh script first."
    exit 1
fi

# Exit early if screensave is already running
pgrep -f org.albibenni.screensaver && exit 0

# Allow screensaver to be turned off but also force started
if [[ -f ~/.local/state/benni/toggles/screensaver-off ]] && [[ $1 != "force" ]]; then
    exit 1
fi

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')
terminal=$(xdg-terminal-exec --print-id)

# Count monitors to launch screensaver on
monitor_count=$(hyprctl monitors -j | jq -r '.[] | .name' | wc -l)

for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
    hyprctl dispatch focusmonitor $m

    case $terminal in
    *Alacritty*)
        hyprctl dispatch exec -- \
            alacritty --class=org.albibenni.screensaver \
            --config-file ~/.config/alacritty/screensaver.toml \
            -e screensaver-with-exit.sh
        # -o window.startup_mode=Fullscreen \
        ;;
    *ghostty*)
        hyprctl dispatch exec -- \
            ghostty --class=org.albibenni.screensaver \
            --font-size=32 \
            -e screensaver-with-exit.sh
        # --fullscreen=true \
        ;;
    *kitty*)
        hyprctl dispatch exec -- \
            kitty --class=org.albibenni.screensaver \
            --override font_size=32 \
            --override window_padding_width=0 \
            -e screensaver-with-exit.sh
        # --start-as=fullscreen \
        ;;
    *)
        notify-send "✋  Screensaver only runs in Alacritty, Ghostty, or Kitty"
        ;;
    esac
done

hyprctl dispatch focusmonitor $focused

# Monitor screensaver instances - kill all if any one closes
(
    sleep 2 # Give time for all instances to start
    while true; do
        current_count=$(pgrep -fc org.albibenni.screensaver)
        if [[ $current_count -gt 0 && $current_count -lt $monitor_count ]]; then
            # One or more closed, kill the rest
            pkill -f org.albibenni.screensaver
            break
        elif [[ $current_count -eq 0 ]]; then
            # All closed
            break
        fi
        sleep 0.5
    done
) &
