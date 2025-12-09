#!/bin/bash

# theme-install: Install a new theme from a git repo
# Usage: theme-install <git-repo-url>

# Source theme management functions
source "$HOME/.config/personal/theme.sh"

if [ -z "$1" ]; then
    echo -e "\e[32mEnter the git repository URL for the theme you want to install\n\e[0m"
    if command -v gum &>/dev/null; then
        REPO_URL=$(gum input --placeholder="Git repo URL for theme" --header="")
    else
        read -p "Git repo URL: " REPO_URL
    fi
else
    REPO_URL="$1"
fi

if [ -z "$REPO_URL" ]; then
    echo "No URL provided, exiting."
    exit 1
fi

THEMES_DIR="$HOME/dotfiles/themes"
THEME_NAME=$(basename "$REPO_URL" .git | sed -E 's/^[a-zA-Z]+-//; s/-theme$//')
THEME_PATH="$THEMES_DIR/$THEME_NAME"

# Remove existing theme if present
if [ -d "$THEME_PATH" ]; then
    echo "Theme '$THEME_NAME' already exists. Removing old version..."
    rm -rf "$THEME_PATH"
fi

# Clone the repo to ~/dotfiles/themes
echo "Cloning theme repository..."
if ! git clone "$REPO_URL" "$THEME_PATH"; then
    echo "Error: Failed to clone theme repo."
    exit 1
fi

echo "Theme '$THEME_NAME' installed successfully!"
echo ""

# Apply the new theme using themeSet function
echo "Applying theme..."
themeSet "$THEME_NAME"
