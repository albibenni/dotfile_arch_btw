#!/bin/bash

echo "Restarting logiops service..."
sudo systemctl restart logid

echo "Checking service status..."
sudo systemctl status logid --no-pager -l

echo ""
echo "Recent logs:"
sudo journalctl -u logid -n 20 --no-pager

echo ""
echo "Detecting Logitech devices..."
logid --dump-devices 2>&1 | grep -i "logitech\|mx master" || echo "No devices detected - logid might not be installed or running"
