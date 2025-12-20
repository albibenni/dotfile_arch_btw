#!/bin/bash

set -e  # Exit on any error

echo "==========================================="
echo "  Network Performance Optimization Setup"
echo "==========================================="
echo ""
echo "This script fixes network buffer sizes that bottleneck high-speed connections."
echo "Default Linux kernel buffers (208 KB) are from the early 2000s and limit"
echo "throughput to ~20 Mbps even on gigabit+ connections."
echo ""

# Check current values
echo "Current network buffer settings:"
echo "  rmem_max: $(cat /proc/sys/net/core/rmem_max) bytes (~$(( $(cat /proc/sys/net/core/rmem_max) / 1024 )) KB)"
echo "  wmem_max: $(cat /proc/sys/net/core/wmem_max) bytes (~$(( $(cat /proc/sys/net/core/wmem_max) / 1024 )) KB)"
echo ""

# Create the sysctl configuration file
SYSCTL_FILE="/etc/sysctl.d/99-network-performance.conf"
echo "Creating network performance configuration: $SYSCTL_FILE"

sudo tee "$SYSCTL_FILE" > /dev/null <<EOF
# Network Performance Tuning for High-Speed Connections
# Created by dotfiles installation script
#
# These values allow TCP auto-tuning to work properly on gigabit+ connections
# Default Linux kernel buffers (208 KB) were set decades ago and throttle
# modern high-speed networks.

# Maximum socket buffer sizes (128 MB)
# These are the hard limits that TCP auto-tuning cannot exceed
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728

# Default socket buffer sizes (16 MB)
# These are the initial buffer sizes for new connections
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
EOF

echo "✓ Configuration file created"
echo ""

# Apply the settings immediately
echo "Applying network buffer settings..."
sudo sysctl -p "$SYSCTL_FILE"
echo ""

# Verify the new settings
echo "✓ New network buffer settings applied:"
echo "  rmem_max: $(cat /proc/sys/net/core/rmem_max) bytes (~$(( $(cat /proc/sys/net/core/rmem_max) / 1024 / 1024 )) MB)"
echo "  wmem_max: $(cat /proc/sys/net/core/wmem_max) bytes (~$(( $(cat /proc/sys/net/core/wmem_max) / 1024 / 1024 )) MB)"
echo "  rmem_default: $(cat /proc/sys/net/core/rmem_default) bytes (~$(( $(cat /proc/sys/net/core/rmem_default) / 1024 / 1024 )) MB)"
echo "  wmem_default: $(cat /proc/sys/net/core/wmem_default) bytes (~$(( $(cat /proc/sys/net/core/wmem_default) / 1024 / 1024 )) MB)"
echo ""

echo "==========================================="
echo "  Network Performance Optimization Complete!"
echo "==========================================="
echo ""
echo "Benefits:"
echo "  ✓ Removes ~20 Mbps bottleneck on high-speed connections"
echo "  ✓ Allows TCP auto-tuning to scale to gigabit+ speeds"
echo "  ✓ Settings persist across reboots"
echo ""
echo "You can test your network speed now - you should see significant improvement!"
echo "Recommended: Test with 'curl -o /dev/null https://proof.ovh.net/files/100Mb.dat'"
echo ""
