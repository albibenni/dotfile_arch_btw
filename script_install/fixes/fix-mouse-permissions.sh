#!/bin/bash

echo "Fixing mouse and input device permissions..."
echo ""

# Check current groups
echo "Current groups:"
groups

echo ""
echo "Adding user to 'input' group (requires sudo)..."
sudo usermod -aG input $USER

echo ""
echo "Groups after adding (you'll need to log out/in for this to take effect):"
id -nG $USER

echo ""
echo "IMPORTANT: You must log out and log back in (or reboot) for group changes to take effect!"
echo ""
echo "After logging back in, run this to verify:"
echo "  groups | grep input"
echo ""
echo "And test with:"
echo "  libinput list-devices | grep -A 15 'Logitech MX Master'"
