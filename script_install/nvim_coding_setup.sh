#!/bin/bash

sudo pacman -S nodejs npm ripgrep gcc build-essential lazygit go

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup update

echo "Go installed to /usr/local/go"
echo "Add 'export PATH=\$PATH:/usr/local/go/bin' to your ~/.bashrc or ~/.zshrc"
