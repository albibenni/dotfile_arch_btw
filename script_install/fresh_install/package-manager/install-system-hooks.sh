#!/usr/bin/env bash
# Install pacman hooks for atomic updates

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$SCRIPT_DIR/../system-hooks"

echo "Installing pacman hooks for atomic updates..."

# Check dependencies
MISSING_DEPS=()
command -v snapper >/dev/null 2>&1 || MISSING_DEPS+=("snapper")
command -v btrfs >/dev/null 2>&1 || MISSING_DEPS+=("btrfs-progs")
command -v checkupdates >/dev/null 2>&1 || MISSING_DEPS+=("pacman-contrib")

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "⚠ Missing dependencies: ${MISSING_DEPS[*]}"
    echo ""
    echo "Please install them first:"
    echo "  bash script_install/fresh_install/system-apps/atomic-updates.sh"
    echo ""
    exit 1
fi

# Ensure hooks directory exists
sudo mkdir -p /etc/pacman.d/hooks/

# Install hooks
if [ -d "$HOOKS_DIR" ]; then
    sudo cp "$HOOKS_DIR"/*.hook /etc/pacman.d/hooks/
    echo "✓ Pacman hooks installed:"
    ls -1 "$HOOKS_DIR"/*.hook | xargs -n1 basename
else
    echo "⚠ Warning: Hooks directory not found: $HOOKS_DIR"
    exit 1
fi

echo ""
echo "Hooks installed successfully!"
echo "Snapshots will be created automatically before package updates."
