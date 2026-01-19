#!/bin/bash

set -e  # Exit on any error

echo "Starting Git installation..."
sudo pacman -S --needed git git-delta

echo "Instlaling Git hub desktop..."
yay -S github-desktop-bin --noconfirm --needed
