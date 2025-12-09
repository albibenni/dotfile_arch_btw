#!/bin/bash

echo "Installing benni-menu dependencies..."
echo ""

# Core interactive CLI tools
echo "→ Installing core CLI tools..."
sudo pacman -S --needed --noconfirm \
    gum \
    fzf \
    git \
    stow

# Security & Authentication
echo ""
echo "→ Installing security & authentication tools..."
sudo pacman -S --needed --noconfirm \
    fprintd \
    usbutils \
    libfido2 \
    pam-u2f

# Power management
echo ""
echo "→ Installing power management..."
sudo pacman -S --needed --noconfirm \
    power-profiles-daemon

echo "Enabling power-profiles-daemon..."
sudo systemctl enable --now power-profiles-daemon.service

# Nerd Fonts (optional but recommended)
echo ""
echo "→ Installing Nerd Fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-meslo-nerd \
    ttf-firacode-nerd \
    ttf-victor-mono-nerd \
    ttf-bitstream-vera-mono-nerd

# Hyprland ecosystem tools
echo ""
echo "→ Installing Hyprland ecosystem tools..."
sudo pacman -S --needed --noconfirm \
    hyprpicker \
    hyprlock \
    hypridle \
    hyprsunset

# Wayland utilities
echo ""
echo "→ Installing Wayland utilities..."
sudo pacman -S --needed --noconfirm \
    swaybg \
    swayosd \
    mako

# File manager
echo ""
echo "→ Installing file manager..."
sudo pacman -S --needed --noconfirm \
    nautilus

# Image viewer
echo ""
echo "→ Installing image viewer..."
sudo pacman -S --needed --noconfirm \
    imv

# Terminal utilities
echo ""
echo "→ Installing terminal utilities..."
sudo pacman -S --needed --noconfirm \
    xdg-utils

# Encryption tools
echo ""
echo "→ Installing encryption tools..."
sudo pacman -S --needed --noconfirm \
    cryptsetup

echo ""
echo "✓ benni-menu dependencies installation complete!"
echo ""
echo "Installed components:"
echo "  Core tools:"
echo "    - gum (interactive CLI)"
echo "    - fzf (fuzzy finder)"
echo "    - git (version control)"
echo "    - stow (symlink manager)"
echo ""
echo "  Security:"
echo "    - fprintd (fingerprint authentication)"
echo "    - libfido2 + pam-u2f (FIDO2 hardware key support)"
echo "    - cryptsetup (disk encryption)"
echo ""
echo "  Power:"
echo "    - power-profiles-daemon (power profile management)"
echo ""
echo "  Fonts:"
echo "    - Meslo, Fira Code, Victor Mono, Bitstream Vera (Nerd Fonts)"
echo ""
echo "  Hyprland:"
echo "    - hyprpicker (color picker)"
echo "    - hyprlock (lock screen)"
echo "    - hypridle (idle daemon)"
echo "    - hyprsunset (blue light filter)"
echo ""
echo "  Wayland:"
echo "    - swaybg (wallpaper)"
echo "    - swayosd (on-screen display)"
echo "    - mako (notifications)"
echo ""
echo "  GUI apps:"
echo "    - nautilus (file manager)"
echo "    - imv (image viewer)"
echo ""
echo "Note: Make sure you also have installed:"
echo "  - Hyprland (script_install/extra/hyprland.sh or other)"
echo "  - Walker (script_install/fresh_install/system-apps/eleph_wlaker.sh)"
echo "  - Waybar (script_install/fresh_install/system-apps/waybar.sh)"
echo "  - yay (AUR helper) for AUR packages"
echo ""
