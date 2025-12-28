#!/bin/bash

set -e # Exit on any error

echo "Starting fnm (Fast Node Manager) installation..."

# Install fnm using yay (AUR) since it's not in official repos
if command -v yay &>/dev/null; then
    echo "Using yay to install fnm-bin..."
    yay -S --noconfirm --needed fnm-bin
else
    echo "yay not found, falling back to official install script..."
    curl -fsSL https://fnm.vercel.app/install | bash
fi

echo "fnm installed successfully."

# Note: Shell integration is handled in bash_init.sh and zshrc
echo "Make sure to reload your shell or restart your terminal."

# INSTALL NODE:

# fnm install --lts
# npm install -g pnpm yarn
