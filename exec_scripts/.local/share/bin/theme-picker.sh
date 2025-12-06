#!/bin/bash

# Interactive theme picker with preview using fzf and terminal image support

THEMES_DIR="$HOME/dotfiles/themes"

# Function to show theme preview
show_preview() {
    local theme="$1"
    local preview_img="$THEMES_DIR/$theme/preview.png"

    if [[ -f "$preview_img" ]]; then
        # Use kitty's icat for image preview if in kitty
        if command -v kitty &>/dev/null && [[ "$TERM" == "xterm-kitty" ]]; then
            kitty +kitten icat --clear --transfer-mode=memory --stdin=no --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" "$preview_img" 2>/dev/null
        # Use chafa for terminal image preview (works with most terminals including Ghostty)
        elif command -v chafa &>/dev/null; then
            chafa -f symbols -s "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$preview_img" 2>/dev/null
        # Use viu as alternative
        elif command -v viu &>/dev/null; then
            viu -w "$FZF_PREVIEW_COLUMNS" "$preview_img" 2>/dev/null
        # Fallback to showing theme info
        else
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "Theme: $theme"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "Preview: $preview_img"
            echo ""
            echo "💡 Tip: Install 'chafa' for image previews:"
            echo "   sudo pacman -S chafa"
            echo ""
            # Show first background if available
            if [[ -d "$THEMES_DIR/$theme/backgrounds" ]]; then
                echo "Backgrounds:"
                ls -1 "$THEMES_DIR/$theme/backgrounds" | head -5
                local count=$(ls -1 "$THEMES_DIR/$theme/backgrounds" | wc -l)
                [[ $count -gt 5 ]] && echo "... and $(($count - 5)) more"
            fi
        fi
    else
        echo "No preview available for '$theme'"
    fi
}

export -f show_preview
export THEMES_DIR

# Get list of themes
themes=$(ls -1 "$THEMES_DIR" | grep -v "README.md")

# Show theme picker with preview using fzf
selected=$(echo "$themes" | fzf \
    --preview 'show_preview {}' \
    --preview-window=right:60%:wrap \
    --height=80% \
    --border=rounded \
    --prompt="Select theme: " \
    --header="Use ↑↓ to navigate, Enter to select, Esc to cancel" \
    --color=16 \
    --cycle)

# If a theme was selected, apply it
if [[ -n "$selected" ]]; then
    theme-next.sh set "$selected"
fi
