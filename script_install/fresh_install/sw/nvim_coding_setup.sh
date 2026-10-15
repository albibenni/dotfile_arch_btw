#!/bin/bash

set -euo pipefail

CODING_PACKAGES=(ripgrep gcc base-devel lazygit go curl)

if command -v node >/dev/null 2>&1; then
    echo "Node.js is already installed; skipping the system package."
else
    CODING_PACKAGES+=(nodejs)
fi

if command -v npm >/dev/null 2>&1; then
    echo "npm is already installed; skipping the system package."
else
    CODING_PACKAGES+=(npm)
fi

sudo pacman -S --needed "${CODING_PACKAGES[@]}"

NPM_PREFIX=$(npm config get prefix)
if [[ -w "$NPM_PREFIX" ]]; then
    npm install -g stylelint stylelint-config-standard
else
    sudo npm install -g stylelint stylelint-config-standard
fi

# Install the global Vite+ CLI only when it is not already available.
if command -v vp >/dev/null 2>&1; then
    echo "Vite+ is already installed; skipping."
else
    curl -fsSL https://vite.plus | VP_NODE_MANAGER=no VP_PM_MANAGER=no bash
fi

# rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#
# rustup update

echo "Go installed to /usr/local/go"
echo "Add 'export PATH=\$PATH:/usr/local/go/bin' to your ~/.bashrc or ~/.zshrc"
