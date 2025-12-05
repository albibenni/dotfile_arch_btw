#!/bin/sh

set -e  # Exit on any error

echo "Starting Git installation..."
sudo pacman -S git

echo "Instlaling Git hub desktop..."
yay -S github-desktop-bin --noconfirm
