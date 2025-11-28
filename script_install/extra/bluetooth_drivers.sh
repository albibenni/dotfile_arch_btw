#!/bin/sh

set -e  # Exit on any error

echo "Starting BlueZ installation on Arch Linux..."

sudo pacman -S bluez bluez-utils

# can check with lsmod | grep btsub running
# else load with modprobe btsub

# Enable and start the Bluetooth service
echo "Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

## bluetoothctl - cli
# bluetoothctl
# power on
# agent on
# default-agent   - this sets the default device to automatically handle pairing
# scan on
# trust <mac address> - can autocomplete with tab
# connect <mac address> - can autocomplete with tab same as trust
# remove <mac address> - remove device from known devices
