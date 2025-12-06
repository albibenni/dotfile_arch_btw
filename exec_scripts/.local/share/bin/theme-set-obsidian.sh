#!/bin/bash

# Set Obsidian theme based on current theme

CURRENT_THEME_LINK="$HOME/.config/current-theme"

# Get current theme
if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
    echo "No theme currently set"
    exit 1
fi

THEME_PATH=$(readlink "$CURRENT_THEME_LINK")
THEME_NAME=$(basename "$THEME_PATH")

# Determine if theme is dark or light based on common theme names
is_dark_theme() {
    local theme="$1"
    # List of known light themes
    if [[ "$theme" =~ (latte|light|flexoki-light|rose-pine) ]]; then
        return 1  # false - it's light
    else
        return 0  # true - it's dark
    fi
}

# Find Obsidian vault config directories (search in common locations)
OBSIDIAN_VAULTS=$(find ~ -path "*/.*obsidian/appearance.json" -type f 2>/dev/null | xargs -I {} dirname {})

if [[ -z "$OBSIDIAN_VAULTS" ]]; then
    echo "No Obsidian vaults found"
    exit 0
fi

# Determine theme mode
if is_dark_theme "$THEME_NAME"; then
    THEME_MODE="obsidian"  # dark mode
else
    THEME_MODE="moonstone"  # light mode
fi

# Update appearance.json in each vault
while IFS= read -r vault_dir; do
    APPEARANCE_FILE="$vault_dir/appearance.json"

    if [[ -f "$APPEARANCE_FILE" ]]; then
        # Update theme using jq
        if command -v jq &>/dev/null; then
            jq --arg mode "$THEME_MODE" '.theme = $mode' "$APPEARANCE_FILE" > "${APPEARANCE_FILE}.tmp" && \
                mv "${APPEARANCE_FILE}.tmp" "$APPEARANCE_FILE"
            echo "Updated Obsidian vault: $(basename "$(dirname "$vault_dir")")"
        fi
    fi
done <<< "$OBSIDIAN_VAULTS"

echo "Obsidian theme set to: $THEME_MODE"
