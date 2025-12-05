#!/bin/bash
# Restart systemd-resolved to apply DNS configuration changes

echo "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

if [ $? -eq 0 ]; then
    echo "✓ DNS resolver restarted successfully"
    echo ""
    echo "Current DNS configuration:"
    resolvectl status | grep -A 3 "Current DNS Server" || true
    exit 0
else
    echo "✗ Failed to restart DNS resolver"
    exit 1
fi
