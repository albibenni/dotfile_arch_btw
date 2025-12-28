#!/bin/bash
# Intel iwlwifi Power Save Disable
# Fixes lag/latency on Intel Wireless cards

echo "Disabling power save for wlan0..."
sudo iw dev wlan0 set power_save off

# Create a persistent NetworkManager dispatcher script (if NM is used later)
# or a systemd service. Since you use systemd-networkd, we'll use a service.

SERVICE_FILE="/etc/systemd/system/iwlwifi-power-off.service"
echo "Creating systemd service: $SERVICE_FILE"

sudo tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=Disable Intel WiFi Power Save
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/iw dev wlan0 set power_save off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now iwlwifi-power-off.service

echo "Checking status..."
iw dev wlan0 get power_save
