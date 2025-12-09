#!/bin/bash

echo "Installing Nerd Fonts via pacman..."
echo ""

# Install Nerd Fonts from official Arch repositories
echo "→ Installing CaskaydiaCove (Cascadia Code) Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-cascadia-code-nerd

echo ""
echo "→ Installing FiraCode Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-firacode-nerd

echo ""
echo "→ Installing JetBrains Mono Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd

echo ""
echo "→ Updating font cache..."
fc-cache -fv

echo ""
echo "✓ Nerd Fonts installation complete!"
echo ""
echo "Installed fonts:"
echo "  - CaskaydiaCove Nerd Font (Cascadia Code)"
echo "  - FiraCode Nerd Font"
echo "  - JetBrains Mono Nerd Font"
echo ""
echo "You can verify installed fonts with:"
echo "  fc-list | grep -i 'nerd'"
