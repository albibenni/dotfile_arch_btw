#!/bin/sh

set -e  # Exit on any error

echo "Installing atomic update system dependencies..."

# Required packages for atomic updates
sudo pacman -S --needed --noconfirm \
    snapper \
    btrfs-progs \
    pacman-contrib

# snapper: For btrfs snapshots (rollback capability)
# btrfs-progs: For btrfs filesystem management
# pacman-contrib: Provides checkupdates command for update notifications

echo "✓ Atomic update dependencies installed"
echo ""

