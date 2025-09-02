#!/bin/sh

set -e  # Exit on any error

echo "Starting YAY installation..."
# https://github.com/Jguer/yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
