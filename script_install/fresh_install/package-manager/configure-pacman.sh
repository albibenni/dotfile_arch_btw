#!/usr/bin/env bash
# Configure pacman with optimized settings from Omarchy

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACMAN_CONF="$SCRIPT_DIR/../configs/pacman.conf"

echo "Configuring pacman..."

# Backup existing config
if [ -f /etc/pacman.conf ]; then
    sudo cp /etc/pacman.conf /etc/pacman.conf.backup-$(date +%s)
    echo "✓ Backed up existing pacman.conf"
fi

# Install optimized config
if [ -f "$PACMAN_CONF" ]; then
    sudo cp "$PACMAN_CONF" /etc/pacman.conf
    echo "✓ Installed optimized pacman.conf"
else
    echo "⚠ Warning: pacman.conf not found at $PACMAN_CONF"
    exit 1
fi

# Check for Apple T2 hardware
if lspci -nn 2>/dev/null | grep -q "106b:180[12]"; then
    echo "✓ Detected Apple T2 hardware, adding arch-mact2 repository..."

    if ! grep -q "\[arch-mact2\]" /etc/pacman.conf; then
        cat <<EOF | sudo tee -a /etc/pacman.conf >/dev/null

[arch-mact2]
Server = https://github.com/NoaHimesaka1873/arch-mact2-mirror/releases/download/release
SigLevel = Never
EOF
        echo "✓ Added arch-mact2 repository"
    else
        echo "✓ arch-mact2 repository already configured"
    fi
fi

# Sync databases
echo ""
echo "Syncing package databases..."
sudo pacman -Sy

echo ""
echo "✓ Pacman configuration complete!"
echo ""
echo "Features enabled:"
echo "  • Color output with ILoveCandy progress bar"
echo "  • VerbosePkgLists for detailed package info"
echo "  • ParallelDownloads = 5 for faster updates"
echo "  • DownloadUser = alpm for security"
