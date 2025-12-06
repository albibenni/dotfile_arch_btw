#!/bin/bash
# Enable and start libvirt service, add user to required groups

set -e

echo "=== Setting up libvirt service ==="

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "Please run as normal user (will use sudo when needed)"
   exit 1
fi

# Enable and start libvirt service
echo "Enabling libvirtd service..."
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Add user to libvirt group
echo "Adding user to libvirt group..."
sudo usermod -aG libvirt $USER

# Verify service is running
if systemctl is-active --quiet libvirtd; then
    echo "✓ libvirtd service is running"
else
    echo "✗ libvirtd service failed to start"
    exit 1
fi

echo ""
echo "✓ libvirt setup complete!"
echo ""
echo "IMPORTANT: You need to log out and log back in for group changes to take effect"
echo "After re-login, run 03-download-windows.sh"
