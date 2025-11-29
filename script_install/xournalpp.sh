#!/bin/bash

set -e  # Exit on any error

echo "Installing Xournal++..."

# Install xournalpp from official repositories
sudo pacman -S xournalpp

echo "Xournal++ installation complete!"
echo "Note: Run 'restore-symlinks' from the dotfiles directory to symlink the configuration."
