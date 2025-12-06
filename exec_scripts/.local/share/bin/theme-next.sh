#!/bin/bash

# Theme management script - handles both background cycling and theme switching

THEMES_DIR="$HOME/dotfiles/themes"
CURRENT_THEME_LINK="$HOME/.config/current-theme"
CURRENT_BG_LINK="$HOME/.config/current-background"

# Cycle to next background in current theme
themeNextBg() {
    # Get current theme
    if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
        notify-send "No theme currently set" -t 2000
        return 1
    fi

    local current_theme=$(basename "$(readlink "$CURRENT_THEME_LINK")")
    local theme_path="$THEMES_DIR/$current_theme"
    local bg_dir="$theme_path/backgrounds"

    if [[ ! -d "$bg_dir" ]]; then
        notify-send "No backgrounds found for theme '$current_theme'" -t 2000
        return 1
    fi

    # Get sorted list of all backgrounds
    mapfile -d '' -t backgrounds < <(find "$bg_dir" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | sort -z)

    if [[ ${#backgrounds[@]} -eq 0 ]]; then
        notify-send "No backgrounds found" -t 2000
        pkill -x swaybg
        setsid uwsm-app -- swaybg --color '#000000' >/dev/null 2>&1 &
        return 1
    fi

    # Get current background
    local current_bg=""
    if [[ -L "$CURRENT_BG_LINK" ]]; then
        current_bg="$(readlink "$CURRENT_BG_LINK")"
    fi

    # Find next background (cycle through sequentially)
    local next_bg=""
    if [[ -z "$current_bg" ]]; then
        # No current background, use first one
        next_bg="${backgrounds[0]}"
    else
        # Find current background in array and get next one
        local found=0
        for i in "${!backgrounds[@]}"; do
            if [[ "${backgrounds[$i]}" == "$current_bg" ]]; then
                # Get next background, wrap around to first if at end
                next_bg="${backgrounds[$(( (i + 1) % ${#backgrounds[@]} ))]}"
                found=1
                break
            fi
        done

        # If current background not found in list, use first one
        if [[ $found -eq 0 ]]; then
            next_bg="${backgrounds[0]}"
        fi
    fi

    if [[ -n "$next_bg" ]]; then
        # Set wallpaper
        pkill -x swaybg
        setsid uwsm-app -- swaybg -i "$next_bg" -m fill >/dev/null 2>&1 &

        # Update background symlink for hyprlock
        ln -nsf "$next_bg" "$CURRENT_BG_LINK"

        notify-send "Background changed" "$(basename "$next_bg")" -t 2000
    fi
}

# Set a theme
themeSet() {
    local theme_name="$1"

    if [[ -z "$theme_name" ]]; then
        notify-send "Error" "No theme name provided" -t 2000
        return 1
    fi

    local theme_path="$THEMES_DIR/$theme_name"

    if [[ ! -d "$theme_path" ]]; then
        notify-send "Error" "Theme '$theme_name' not found" -t 2000
        return 1
    fi

    # Update symlink
    ln -nsf "$theme_path" "$CURRENT_THEME_LINK"

    # Set random background from theme
    if [[ -d "$theme_path/backgrounds" ]]; then
        local bg=$(find "$theme_path/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        if [[ -n "$bg" ]]; then
            # Set wallpaper
            pkill -x swaybg
            setsid uwsm-app -- swaybg -i "$bg" -m fill >/dev/null 2>&1 &

            # Create background symlink for hyprlock
            ln -nsf "$bg" "$CURRENT_BG_LINK"
        fi
    fi

    # Restart components to apply new theme
    if pgrep -x waybar >/dev/null; then
        pkill -x waybar
        setsid uwsm-app -- waybar >/dev/null 2>&1 &
    fi

    if pgrep -x swayosd-server >/dev/null; then
        pkill -x swayosd-server
        setsid uwsm-app -- swayosd-server >/dev/null 2>&1 &
    fi

    # Reload hyprland
    hyprctl reload >/dev/null 2>&1

    # Reload mako
    if pgrep -x mako >/dev/null; then
        makoctl reload
    fi

    # Reload btop if running
    if pgrep -x btop >/dev/null; then
        pkill -SIGUSR2 btop
    fi

    notify-send "Theme applied" "$theme_name" -t 2000
}

# Main script logic
case "${1:-next-bg}" in
    next-bg)
        themeNextBg
        ;;
    set)
        themeSet "$2"
        ;;
    *)
        echo "Usage: $0 [next-bg|set <theme-name>]"
        echo "  next-bg         - Cycle to next background (default)"
        echo "  set <name>      - Set a specific theme"
        exit 1
        ;;
esac
