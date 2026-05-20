#!/bin/bash

echo "Installing Pokémon Emulators..."

# 1. RetroArch - The all-in-one solution for almost everything
echo "Installing RetroArch (All-in-one)..."
sudo pacman -S --needed --noconfirm retroarch

# 2. Standalone Emulators for better performance/features
echo "Installing standalone emulators and dependencies..."

# Dependencies for MelonDS and other emulators
sudo pacman -S --needed --noconfirm faad2 enet

# mGBA - Best for Game Boy, Color, and Advance
sudo pacman -S --needed --noconfirm mgba-qt

# MelonDS - Best for Nintendo DS (Binary version)
yay -S --needed --noconfirm melonds-bin

# Lime3DS - Successor to Citra for Nintendo 3DS (AppImage version)
yay -S --needed --noconfirm lime3ds-appimage

echo ""
echo "✓ Pokémon Emulator setup complete!"
echo ""
echo "Installed Emulators:"
echo "  • RetroArch: All-in-one (GB, GBC, GBA, NDS, etc.)"
echo "  • mGBA: Dedicated GB/GBA emulator (Highly recommended)"
echo "  • MelonDS: Dedicated Nintendo DS emulator"
echo "  • Lime3DS: Dedicated Nintendo 3DS emulator"
echo ""
echo "--- NEXT STEPS ---"
echo "1. ROMs: You must provide your own game files (.gb, .gba, .nds, .3ds)."
echo "2. BIOS: Nintendo DS and 3DS may require BIOS/Firmware files for full compatibility."
echo "3. SETUP: Open RetroArch and go to 'Online Updater' -> 'Core Downloader' to install cores like 'mGBA' or 'MelonDS'."
echo ""
echo "Happy gaming!"
