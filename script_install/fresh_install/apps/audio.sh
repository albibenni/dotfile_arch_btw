#!/bin/bash

echo "Installing audio stack..."

# Core PipeWire audio system
sudo pacman -S --needed --noconfirm \
    pipewire \
    pipewire-alsa \
    pipewire-audio \
    pipewire-jack \
    pipewire-pulse \
    wireplumber \
    gst-plugin-pipewire \
    lib32-pipewire \
    lib32-libpipewire

# Audio control utilities
sudo pacman -S --needed --noconfirm \
    pamixer \
    wiremix \
    playerctl \
    swayosd \
    jq

echo "Enabling PipeWire services..."
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service

echo "Audio stack installation complete!"
echo ""
echo "Installed components:"
echo "  - PipeWire (audio server)"
echo "  - WirePlumber (session manager)"
echo "  - pamixer (CLI volume control)"
echo "  - wiremix (TUI audio mixer)"
echo "  - playerctl (media player control)"
echo "  - swayosd (on-screen display)"
