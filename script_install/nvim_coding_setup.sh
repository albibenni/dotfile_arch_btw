#!/bin/bash

sudo pacman -S nodejs npm ripgrep gcc base-devel lazygit go

sudo npm install -g stylelint stylelint-config-standard

# rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#
# rustup update

echo "Go installed to /usr/local/go"
echo "Add 'export PATH=\$PATH:/usr/local/go/bin' to your ~/.bashrc or ~/.zshrc"

