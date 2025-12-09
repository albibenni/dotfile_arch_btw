#!/usr/bin/env bash
# Configure yay with optimized settings from Omarchy

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAY_CONFIG="$SCRIPT_DIR/../configs/yay-config.json"

echo "Configuring yay..."

# Check if yay is installed
if ! command -v yay &>/dev/null; then
    echo "⚠ yay is not installed"
    echo ""
    read -p "Install yay now? [Y/n] " -n 1 -r INSTALL_YAY
    echo ""

    if [[ $INSTALL_YAY =~ ^[Yy]$ ]] || [[ -z $INSTALL_YAY ]]; then
        echo "Installing yay..."

        # Install dependencies
        sudo pacman -S --needed --noconfirm base-devel git

        # Clone and build yay
        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~
        rm -rf "$TMP_DIR"

        echo "✓ yay installed"
    else
        echo "Skipping yay installation."
        exit 0
    fi
fi

# Create config directory
mkdir -p ~/.config/yay

# Backup existing config
if [ -f ~/.config/yay/config.json ]; then
    cp ~/.config/yay/config.json ~/.config/yay/config.json.backup-$(date +%s)
    echo "✓ Backed up existing yay config"
fi

# Install optimized config
if [ -f "$YAY_CONFIG" ]; then
    cp "$YAY_CONFIG" ~/.config/yay/config.json
    echo "✓ Installed optimized yay config"
else
    echo "⚠ Warning: yay config not found at $YAY_CONFIG"
    exit 1
fi

echo ""
echo "✓ Yay configuration complete!"
echo ""
echo "Features enabled:"
echo "  • answerclean = None (don't ask to clean build files)"
echo "  • answerdiff = None (don't ask to show diffs)"
echo "  • removemake = yes (remove make dependencies)"
echo "  • cleanAfter = true (clean build files after install)"
echo "  • batchinstall = true (install packages in batches)"
echo "  • sortby = votes (sort AUR results by votes)"
