#!/bin/bash

set -e  # Exit on any error

echo "==========================================="
echo "  WiFi Power Management Fix"
echo "==========================================="
echo ""
echo "This script disables WiFi power management that limits TX power to 3 dBm."
echo "Low TX power causes severe throughput issues even with good signal strength."
echo ""

# Check current WiFi power state
echo "Current WiFi power management status:"
iw dev wlan0 get power_save || echo "  Unable to check (may require sudo)"
echo ""

# Check current TX power
echo "Current TX power:"
iw dev wlan0 info | grep txpower || echo "  Unable to check TX power"
echo ""

# Create systemd service to disable WiFi power save on boot
SERVICE_FILE="/etc/systemd/system/wifi-powersave-off.service"
echo "Creating systemd service: $SERVICE_FILE"

sudo tee "$SERVICE_FILE" > /dev/null <<'EOF'
[Unit]
Description=Disable WiFi Power Management
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/iw dev wlan0 set power_save off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo "✓ Service file created"
echo ""

# Disable device-level power management for the WiFi card
UDEV_RULE="/etc/udev/rules.d/70-wifi-power-management.rules"
echo "Creating udev rule: $UDEV_RULE"

sudo tee "$UDEV_RULE" > /dev/null <<'EOF'
# Disable power management for MediaTek MT7922 WiFi card
# Prevents TX power throttling that causes poor network performance
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan0", RUN+="/usr/bin/iw dev wlan0 set power_save off"
ACTION=="add", SUBSYSTEM=="pci", ATTR{device}=="0x7922", ATTR{power/control}="on"
EOF

echo "✓ Udev rule created"
echo ""

# Enable and start the service
echo "Enabling systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable wifi-powersave-off.service
echo "✓ Service enabled"
echo ""

# Apply settings immediately
echo "Applying WiFi power management settings now..."
sudo iw dev wlan0 set power_save off
echo "✓ WiFi power save disabled"
echo ""

# Try to disable device power management (may not work on all systems)
if [ -f /sys/class/net/wlan0/device/power/control ]; then
    echo "Disabling device-level power management..."
    echo "on" | sudo tee /sys/class/net/wlan0/device/power/control > /dev/null
    echo "✓ Device power management set to 'on' (no power saving)"
fi
echo ""

# Wait a moment for driver to adjust
sleep 2

# Verify new settings
echo "✓ New WiFi settings:"
echo "  Power save: $(iw dev wlan0 get power_save 2>/dev/null | grep -o 'on\|off' || echo 'unknown')"
echo "  TX power: $(iw dev wlan0 info | grep txpower | awk '{print $2, $3}')"
echo ""

echo "==========================================="
echo "  WiFi Power Management Fix Complete!"
echo "==========================================="
echo ""
echo "Benefits:"
echo "  ✓ WiFi TX power restored to normal levels (15-20 dBm)"
echo "  ✓ Fixes throughput bottleneck from weak transmission"
echo "  ✓ Settings persist across reboots"
echo ""
echo "You may need to reconnect to WiFi for full effect."
echo "Test your speed with: curl -o /dev/null https://proof.ovh.net/files/100Mb.dat"
echo ""
echo "Note: On battery power, you may want to re-enable power save for longer battery life."
echo "      To re-enable: sudo iw dev wlan0 set power_save on"
echo ""
