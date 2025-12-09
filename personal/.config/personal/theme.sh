#!/bin/bash
# Theme management functions

THEMES_DIR="$HOME/dotfiles/themes"
CURRENT_THEME_LINK="$HOME/.config/current-theme"
CURRENT_BG_LINK="$HOME/.config/current-background"

# List available themes
themeList() {
    echo "Available themes:"
    ls -1 "$THEMES_DIR" | nl -w2 -s'. '
}

# Get current theme name
themeCurrent() {
    if [ -L "$CURRENT_THEME_LINK" ]; then
        basename "$(readlink "$CURRENT_THEME_LINK")"
    else
        echo "No theme set"
        return 1
    fi
}

# Show theme preview
themePreview() {
    local theme_name="${1:-$(themeCurrent)}"
    local preview_img="$THEMES_DIR/$theme_name/preview.png"

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

    local theme_path="$THEMES_DIR/$theme_name"

    if [[ ! -d "$theme_path" ]]; then
        echo "Theme '$theme_name' not found in $THEMES_DIR"
        echo ""
        themeList
        return 1
    fi

    echo "Applying theme: $theme_name"

    # Update symlink
    ln -nsf "$theme_path" "$CURRENT_THEME_LINK"

    # Set random background from theme
    if [ -d "$theme_path/backgrounds" ]; then
        local bg=$(find "$theme_path/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        if [ -n "$bg" ]; then
            # Set wallpaper
            pkill swaybg
            setsid uwsm-app -- swaybg -i "$bg" -m fill >/dev/null 2>&1 &

            # Create background symlink for hyprlock
            ln -nsf "$bg" "$CURRENT_BG_LINK"

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

    # Change gnome, browser, vscode, cursor, obsidian themes
    if command -v theme-set-gnome.sh >/dev/null 2>&1; then
        theme-set-gnome.sh 2>/dev/null && echo "✓ GNOME theme updated"
    fi

    if command -v theme-set-browser.sh >/dev/null 2>&1; then
        theme-set-browser.sh 2>/dev/null && echo "✓ Browser theme updated"
    fi

    if command -v theme-set-vscode.sh >/dev/null 2>&1; then
        theme-set-vscode.sh 2>/dev/null && echo "✓ VSCode theme updated"
    fi

    if command -v theme-set-cursor.sh >/dev/null 2>&1; then
        theme-set-cursor.sh 2>/dev/null && echo "✓ Cursor theme updated"
    fi

    if command -v theme-set-obsidian.sh >/dev/null 2>&1; then
        theme-set-obsidian.sh 2>/dev/null && echo "✓ Obsidian theme updated"
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

    local theme_path="$THEMES_DIR/$current_theme"
    local bg_dir="$theme_path/backgrounds"

    if [ ! -d "$bg_dir" ]; then
        echo "No backgrounds found for theme '$current_theme'"
        return 1
    fi

    # Get sorted list of all backgrounds
    local backgrounds=($(find "$bg_dir" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort))

    if [ ${#backgrounds[@]} -eq 0 ]; then
        echo "No backgrounds found"
        return 1
    fi

    # Get current background
    local current_bg=""
    if [ -L "$CURRENT_BG_LINK" ]; then
        current_bg="$(readlink "$CURRENT_BG_LINK")"
    fi

    # Find next background (cycle through sequentially)
    local next_bg=""
    if [ -z "$current_bg" ]; then
        # No current background, use first one
        next_bg="${backgrounds[0]}"
    else
        # Find current background in array and get next one
        local found=0
        for i in "${!backgrounds[@]}"; do
            if [ "${backgrounds[$i]}" = "$current_bg" ]; then
                # Get next background, wrap around to first if at end
                next_bg="${backgrounds[$(((i + 1) % ${#backgrounds[@]}))]}"
                found=1
                break
            fi
        done

        # If current background not found in list, use first one
        if [ $found -eq 0 ]; then
            next_bg="${backgrounds[0]}"
        fi
    fi

    if [ -n "$next_bg" ]; then
        # Set wallpaper
        pkill swaybg
        setsid uwsm-app -- swaybg -i "$next_bg" -m fill >/dev/null 2>&1 &

        # Update background symlink for hyprlock
        ln -nsf "$next_bg" "$CURRENT_BG_LINK"

        echo "Background changed: $(basename "$next_bg")"
    else
        echo "No backgrounds found"
    fi
}

# Interactive theme picker using fzf
themePicker() {
    local theme=$(ls -1 "$THEMES_DIR" | fzf --preview "cat $THEMES_DIR/{}/preview.png 2>/dev/null || echo 'No preview available'" --preview-window=right:60% --height=50% --border --prompt="Select theme: ")

    if [ -n "$theme" ]; then
        themeSet "$theme"
    fi
}
