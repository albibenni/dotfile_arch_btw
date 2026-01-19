#!/bin/bash

set -e  # Exit on any error

echo "Starting Terminal installation..."

echo "Install Zsh..."
sudo pacman -S zsh
echo "Set Zsh as default Shell..."
sudo chsh -s $(which zsh)

echo "Install Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Setup Autosuggestion for zsh and ohmyzsh"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
echo "Setup Higlight for zsh and ohmyzsh"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# add nerdfont



echo "Setup Zsh..."
sudo pacman -S ghostty

