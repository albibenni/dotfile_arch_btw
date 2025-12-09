#!/bin/bash

echo "Installing Waybar and its dependencies..."

# Core Waybar and status bar utilities
sudo pacman -S --needed --noconfirm \
    waybar \
    btop \
    brightnessctl \
    ddcutil \
    upower \
    bluetui

echo "Waybar and dependencies installation complete!"
echo ""
echo "Installed components:"
echo "  - waybar (status bar for Wayland)"
echo "  - btop (system monitor for CPU widget)"
echo "  - brightnessctl (laptop brightness control)"
echo "  - ddcutil (external monitor brightness via DDC/CI)"
echo "  - upower (battery status)"
echo "  - bluetui (TUI for bluetooth management)"
echo ""
echo "Note: Make sure you also have installed:"
echo "  - Hyprland (script_install/extra/hyprland.sh)"
echo "  - Audio stack (script_install/fresh_install/apps/audio.sh)"
echo "  - Walker (script_install/fresh_install/system-apps/eleph_wlaker.sh)"
echo "  - Bluetooth drivers (script_install/extra/bluetooth_drivers.sh)"
