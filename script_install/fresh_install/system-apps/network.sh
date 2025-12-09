#!/bin/bash

echo "Installing network management tools..."

# NetworkManager and wifi TUI
sudo pacman -S --needed --noconfirm \
    networkmanager \
    network-manager-applet \
    impala

echo "Enabling NetworkManager service..."
sudo systemctl enable --now NetworkManager.service

echo "Network management tools installation complete!"
echo ""
echo "Installed components:"
echo "  - NetworkManager (network connection manager)"
echo "  - network-manager-applet (system tray applet)"
echo "  - impala (TUI for managing WiFi)"
echo ""
echo "Usage:"
echo "  - Use 'impala' for TUI WiFi management"
echo "  - Use 'nmcli' for CLI network control"
echo "  - Use 'nmtui' for text-based UI"
