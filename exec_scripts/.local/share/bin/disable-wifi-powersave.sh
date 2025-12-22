#!/bin/bash
# Disable WiFi power saving for Intel AX210
# This prevents intermittent connection drops on AC-powered systems
# STEPS:
# sudo cp /home/albibenni/dotfiles/system_config/iwlwifi-disable-powersave.conf /etc/modprobe.d/
# sudo cp /home/albibenni/dotfiles/system_config/disable-wifi-powersave.service /etc/systemd/system/
# sudo systemctl daemon-reload && sudo systemctl enable disable-wifi-powersave.service
# sudo iw dev wlan0 set power_save off

WIFI_INTERFACE="wlan0"

# Wait for interface to be available
for i in {1..10}; do
    if ip link show "$WIFI_INTERFACE" &>/dev/null; then
        break
    fi
    sleep 1
done

# Disable power saving
if ip link show "$WIFI_INTERFACE" &>/dev/null; then
    iw dev "$WIFI_INTERFACE" set power_save off
    echo "WiFi power saving disabled on $WIFI_INTERFACE"
else
    echo "Warning: $WIFI_INTERFACE not found"
    exit 1
fi
