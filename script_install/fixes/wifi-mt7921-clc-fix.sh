#!/bin/bash

set -e  # Exit on any error

echo "==========================================="
echo "  MT7921E Driver CLC Bug Fix"
echo "==========================================="
echo ""
echo "This script disables CLC (Country Location Configuration) which is"
echo "causing a bug that limits TX power to 3 dBm on DFS channels."
echo ""
echo "CLC was introduced in kernel 6.7 but incorrectly enforces low power."
echo "After applying this fix, TX power should increase to 20+ dBm."
echo ""

# Check current TX power
echo "Current WiFi status:"
iw dev wlan0 info | grep -E "txpower|channel" || echo "  Unable to check (WiFi may be down)"
echo ""

# Create modprobe configuration
MODPROBE_FILE="/etc/modprobe.d/mt7921.conf"
echo "Creating modprobe configuration: $MODPROBE_FILE"

sudo tee "$MODPROBE_FILE" > /dev/null <<'EOF'
# Disable CLC (Country Location Configuration) for MT7921 WiFi driver
# This fixes a bug where TX power is incorrectly limited to 3 dBm
#
# Bug details: CLC enforcement introduced in kernel 6.7 incorrectly
# limits transmit power on DFS channels, causing severe performance issues
#
# IMPORTANT: The parameter must be set on mt7921_common, NOT mt7921e
options mt7921_common disable_clc=1
EOF

echo "✓ Modprobe configuration created"
echo ""

# Rebuild initramfs to include the new configuration
echo "Rebuilding initramfs..."
if command -v mkinitcpio &> /dev/null; then
    sudo mkinitcpio -P
    echo "✓ Initramfs rebuilt (Arch/Manjaro)"
elif command -v update-initramfs &> /dev/null; then
    sudo update-initramfs -u
    echo "✓ Initramfs rebuilt (Debian/Ubuntu)"
else
    echo "⚠ Could not detect initramfs tool. Module will load on next boot."
fi
echo ""

# Reload the driver module
echo "Reloading mt7921e driver module..."
echo "Note: This will temporarily disconnect your WiFi"
echo ""

# Check if module is loaded
if lsmod | grep -q mt7921e; then
    echo "Unloading mt7921e module..."
    sudo modprobe -r mt7921e
    sleep 2
    echo "✓ Module unloaded"
fi

echo "Loading mt7921e module with disable_clc=1..."
sudo modprobe mt7921e
sleep 3
echo "✓ Module loaded"
echo ""

# Wait for WiFi interface to come up
echo "Waiting for WiFi interface..."
sleep 2

# Reconnect to WiFi
echo "Reconnecting to WiFi..."
sudo iwctl station wlan0 connect "BenniLili 5Gz" || echo "⚠ Auto-reconnect failed. Please reconnect manually."
sleep 3
echo ""

# Verify new TX power
echo "==========================================="
echo "  Verification"
echo "==========================================="
echo ""

echo "New WiFi status:"
iw dev wlan0 info | grep -E "txpower|channel|bitrate" || echo "  WiFi not connected yet"
echo ""

# Check if CLC is disabled
echo "Checking if CLC is disabled:"
if [ -f /sys/module/mt7921_common/parameters/disable_clc ]; then
    CLC_STATUS=$(cat /sys/module/mt7921_common/parameters/disable_clc)
    if [ "$CLC_STATUS" = "Y" ]; then
        echo "  ✓ CLC is DISABLED (disable_clc=Y)"
    else
        echo "  ✗ CLC is still ENABLED (disable_clc=N)"
        echo "  The fix may not have applied correctly."
    fi
else
    echo "  ⚠ Cannot verify (parameter file not found)"
fi
echo ""

echo "==========================================="
echo "  MT7921E CLC Bug Fix Complete!"
echo "==========================================="
echo ""
echo "Expected results:"
echo "  ✓ TX power should increase from 3 dBm to 20+ dBm"
echo "  ✓ WiFi speed should improve dramatically"
echo "  ✓ Fix persists across reboots"
echo ""
echo "If TX power is still low:"
echo "  1. Try switching your router to a non-DFS channel (36-48)"
echo "  2. Verify with: cat /sys/module/mt7921_common/parameters/disable_clc"
echo "  3. Check if reconnected to WiFi successfully"
echo ""
echo "Test your speed with:"
echo "  curl -o /dev/null https://proof.ovh.net/files/100Mb.dat"
echo ""
