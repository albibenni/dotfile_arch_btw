#!/bin/bash

# Set VSCode theme based on current theme

CURRENT_THEME_LINK="$HOME/.config/current-theme"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"

# Get current theme
if [[ ! -L "$CURRENT_THEME_LINK" ]]; then
    echo "No theme currently set"
    exit 1
fi

THEME_PATH=$(readlink "$CURRENT_THEME_LINK")
VSCODE_THEME_FILE="$THEME_PATH/vscode.json"

if [[ ! -f "$VSCODE_THEME_FILE" ]]; then
    echo "No VSCode theme config found for current theme"
    exit 1
fi

# Read theme info from vscode.json
THEME_NAME=$(jq -r '.name' "$VSCODE_THEME_FILE" 2>/dev/null)
THEME_EXTENSION=$(jq -r '.extension' "$VSCODE_THEME_FILE" 2>/dev/null)

if [[ -z "$THEME_NAME" || "$THEME_NAME" == "null" ]]; then
    echo "Invalid VSCode theme configuration"
    exit 1
fi

# Create VSCode settings directory if it doesn't exist
mkdir -p "$(dirname "$VSCODE_SETTINGS")"

# Update or create settings.json with the new theme
if [[ -f "$VSCODE_SETTINGS" ]]; then
    # Strip comments and update existing settings
    # VSCode settings can have comments, so we use a more lenient approach
    if grep -q "workbench.colorTheme" "$VSCODE_SETTINGS"; then
        # Replace existing theme line
        sed -i "s/\"workbench.colorTheme\":.*/\"workbench.colorTheme\": \"$THEME_NAME\",/" "$VSCODE_SETTINGS"
    else
        # Add theme line after first opening brace
        sed -i "1 a\    \"workbench.colorTheme\": \"$THEME_NAME\"," "$VSCODE_SETTINGS"
    fi
else
    # Create new settings
    echo "{\"workbench.colorTheme\": \"$THEME_NAME\"}" > "$VSCODE_SETTINGS"
fi

echo "VSCode theme set to: $THEME_NAME"
