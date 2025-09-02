#!/bin/sh

set -e  # Exit on any error

echo "Starting Terminal installation..."

echo "Install Zsh..."
sudo pacman -S zsh
echo "Set Zsh as default Shell..."
sudo chsh -s $(which zsh)

echo "Install Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# add nerdfont

echo "Setup Zsh..."
sudo pacman -S ghostty

