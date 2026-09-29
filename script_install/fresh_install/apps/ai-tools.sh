#!/bin/bash

set -euo pipefail

DESKTOP_PACKAGES=(
    codex-app-bin
    antigravity
    claude-desktop
)

# Desktop apps are managed through the AUR.
yay -S --needed "${DESKTOP_PACKAGES[@]}"

# Match Omarchy's existing mise-backed, self-updating CLI setup.
omarchy-mise-install codex
omarchy-mise-install claude

# Antigravity CLI is distributed through Google's official installer as `agy`.
if command -v agy &>/dev/null; then
    echo "Antigravity CLI is already installed; skipping."
else
    curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --skip-path
fi
