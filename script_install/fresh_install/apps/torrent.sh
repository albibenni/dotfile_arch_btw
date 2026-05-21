#!/bin/bash

# Check if qbittorrent-nox is installed and remove it to prefer the GUI version
if pacman -Qs qbittorrent-nox > /dev/null; then
    echo "Transitioning from qbittorrent-nox to qbittorrent GUI..."
    sudo pacman -Rs --noconfirm qbittorrent-nox
fi

sudo pacman -S --needed --noconfirm qbittorrent
