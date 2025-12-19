#!/bin/bash
# Restart systemd-resolved to apply DNS configuration changes

echo "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

if [ $? -eq 0 ]; then
    echo "✓ DNS resolver restarted successfully"

    # Flush DNS cache to clear any stale entries
    echo "Flushing DNS cache..."
    sudo resolvectl flush-caches
    echo "✓ DNS cache flushed"
    echo ""

    # Wait a moment for systemd-resolved to fully update
    sleep 0.5

    echo "Current DNS configuration:"
    resolvectl status | grep -A 5 "^Global"
    exit 0
else
    echo "✗ Failed to restart DNS resolver"
    exit 1
fi
