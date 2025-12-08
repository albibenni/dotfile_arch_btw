#!/bin/bash

echo "Fixing Logitech MX Master 3 hidraw permissions for logiops..."
echo ""

# Create udev rule to give users in 'input' group access to Logitech hidraw devices
echo "Creating udev rule at /etc/udev/rules.d/99-logitech-hidraw.rules..."
sudo tee /etc/udev/rules.d/99-logitech-hidraw.rules > /dev/null <<'EOF'
# Give input group access to Logitech devices for logiops
# This allows logiops to control MX Master and other Logitech devices
# Works for both USB and Bluetooth Logitech devices (vendor ID: 046d)
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="*046D:*", MODE="0660", GROUP="input"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="input"
EOF

echo ""
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo ""
echo "Current hidraw devices for Logitech:"
ls -la /dev/hidraw* 2>/dev/null | grep -v "total" || echo "No hidraw devices found"

echo ""
echo "Waiting 2 seconds for udev to apply..."
sleep 2

echo ""
echo "Restarting logiops service..."
sudo systemctl restart logid

echo ""
echo "Checking logid status..."
sudo systemctl status logid --no-pager -l

echo ""
echo "Recent logid logs (checking for device add success):"
sleep 1
sudo journalctl -u logid -n 20 --no-pager

echo ""
echo "✓ Fix complete!"
echo ""
echo "If you still see errors, try:"
echo "  1. Unplug and replug your mouse"
echo "  2. Run: sudo systemctl restart logid"
echo "  3. Check logs: sudo journalctl -u logid -f"
