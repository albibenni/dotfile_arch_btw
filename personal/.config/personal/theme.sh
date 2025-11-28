#!/bin/bash
# Theme management functions

ALBI_THEMES_DIR="$HOME/dotfiles/themes"
ALBI_CURRENT_THEME_LINK="$HOME/.config/current-theme"

# List available themes
themeList() {
    echo "Available themes:"
    ls -1 "$ALBI_THEMES_DIR" | nl -w2 -s'. '
}

# Get current theme name
themeCurrent() {
    if [ -L "$ALBI_CURRENT_THEME_LINK" ]; then
        basename "$(readlink "$ALBI_CURRENT_THEME_LINK")"
    else
        echo "No theme set"
        return 1
    fi
}

# Show theme preview
themePreview() {
    local theme_name="${1:-$(themeCurrent)}"
    local preview_img="$ALBI_THEMES_DIR/$theme_name/preview.png"

    if [ -f "$preview_img" ]; then
        imv "$preview_img" &
    else
        echo "No preview available for '$theme_name'"
    fi
}

# Set a theme
themeSet() {
    local theme_name="$1"

    if [ -z "$theme_name" ]; then
        echo "Usage: themeSet <theme-name>"
        echo ""
        themeList
        return 1
    fi

    local theme_path="$ALBI_THEMES_DIR/$theme_name"

    if [[ ! -d "$theme_path" ]]; then
        echo "Theme '$theme_name' not found in $ALBI_THEMES_DIR"
        echo ""
        themeList
        return 1
    fi

    echo "Applying theme: $theme_name"

    # Update symlink
    ln -nsf "$theme_path" "$ALBI_CURRENT_THEME_LINK"

    # Set random background from theme
    if [ -d "$theme_path/backgrounds" ]; then
        local bg=$(find "$theme_path/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        if [ -n "$bg" ]; then
            pkill swaybg
            setsid uwsm-app -- swaybg -i "$bg" -m fill >/dev/null 2>&1 &
            echo "✓ Background set"
        fi
    fi

    # Restart components to apply new theme
    if pgrep -x waybar >/dev/null; then
        restartWaybar
        echo "✓ Waybar restarted"
    fi

    if pgrep -x swayosd-server >/dev/null; then
        restartSwayOsd
        echo "✓ SwayOSD restarted"
    fi

    # Reload hyprland
    hyprctl reload >/dev/null 2>&1
    echo "✓ Hyprland reloaded"

    # Reload mako
    if pgrep -x mako >/dev/null; then
        makoctl reload
        echo "✓ Mako reloaded"
    fi

    # Reload btop if running
    if pgrep -x btop >/dev/null; then
        pkill -SIGUSR2 btop
        echo "✓ btop reloaded"
    fi

    echo ""
    echo "Theme '$theme_name' applied successfully!"
}

# Cycle to next background in current theme
themeNextBg() {
    local current_theme="$(themeCurrent)"
    if [ $? -ne 0 ]; then
        echo "No theme currently set"
        return 1
    fi

    local theme_path="$ALBI_THEMES_DIR/$current_theme"
    local bg_dir="$theme_path/backgrounds"

    if [ ! -d "$bg_dir" ]; then
        echo "No backgrounds found for theme '$current_theme'"
        return 1
    fi

    # Get random background
    local bg=$(find "$bg_dir" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)

    if [ -n "$bg" ]; then
        pkill swaybg
        setsid uwsm-app -- swaybg -i "$bg" -m fill >/dev/null 2>&1 &
        echo "Background changed: $(basename "$bg")"
    else
        echo "No backgrounds found"
    fi
}

# Interactive theme picker using fzf
themePicker() {
    local theme=$(ls -1 "$ALBI_THEMES_DIR" | fzf --preview "cat $ALBI_THEMES_DIR/{}/preview.png 2>/dev/null || echo 'No preview available'" --preview-window=right:60% --height=50% --border --prompt="Select theme: ")

    if [ -n "$theme" ]; then
        themeSet "$theme"
    fi
}
