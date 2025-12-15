#!/bin/bash
# Interactive DNS changer for systemd-resolved

CONFIG_FILE="/etc/systemd/resolved.conf"

echo "DNS Configuration Manager"
echo "========================="
echo ""
echo "Select DNS provider:"
echo "1) Cloudflare (1.1.1.1) - Fast, privacy-focused"
echo "2) Google (8.8.8.8) - Reliable, widely used"
echo "3) Quad9 (9.9.9.9) - Security-focused, blocks malware"
echo "4) Router (default) - Use router's DNS (may have EDNS0 issues)"
echo "5) Cancel"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
1)
    DNS_SERVERS="1.1.1.1 1.0.0.1"
    PROVIDER="Cloudflare"
    ;;
2)
    DNS_SERVERS="8.8.8.8 8.8.4.4"
    PROVIDER="Google"
    ;;
3)
    DNS_SERVERS="9.9.9.9 149.112.112.112"
    PROVIDER="Quad9"
    ;;
4)
    DNS_SERVERS=""
    PROVIDER="Router"
    ;;
5)
    echo "Cancelled."
    exit 0
    ;;
*)
    echo "Invalid choice."
    exit 1
    ;;
esac

echo ""
echo "Updating DNS configuration to: $PROVIDER"

# Create backup with fixed timestamp
BACKUP_FILE="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
sudo cp "$CONFIG_FILE" "$BACKUP_FILE"

# Clean up old backups, keeping only the most recent one
OLD_BACKUPS=$(sudo ls -t ${CONFIG_FILE}.backup.* 2>/dev/null | tail -n +2)
if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | xargs -r sudo rm
    echo "✓ Cleaned up old backup files"
fi

if [ -z "$DNS_SERVERS" ]; then
    # Router option - comment out DNS= and Domains= lines
    sudo sed -i 's/^DNS=/#DNS=/' "$CONFIG_FILE"
    sudo sed -i 's/^Domains=/#Domains=/' "$CONFIG_FILE"
    echo "✓ Configured to use router's DNS"
else
    # Public DNS option - uncomment and set DNS= line
    if grep -q "^DNS=" "$CONFIG_FILE"; then
        # Line exists and is uncommented, replace it
        sudo sed -i "s/^DNS=.*/DNS=$DNS_SERVERS/" "$CONFIG_FILE"
    elif grep -q "^#DNS=" "$CONFIG_FILE"; then
        # Line exists but is commented, uncomment and replace
        sudo sed -i "s/^#DNS=.*/DNS=$DNS_SERVERS/" "$CONFIG_FILE"
    else
        # Line doesn't exist, add it under [Resolve]
        sudo sed -i "/^\[Resolve\]/a DNS=$DNS_SERVERS" "$CONFIG_FILE"
    fi

    # Set Domains=~. to prioritize global DNS over per-link DNS
    # This prevents conflicts with DHCP-provided DNS servers
    if grep -q "^Domains=" "$CONFIG_FILE"; then
        sudo sed -i "s/^Domains=.*/Domains=~./" "$CONFIG_FILE"
    elif grep -q "^#Domains=" "$CONFIG_FILE"; then
        sudo sed -i "s/^#Domains=.*/Domains=~./" "$CONFIG_FILE"
    else
        sudo sed -i "/^\[Resolve\]/a Domains=~." "$CONFIG_FILE"
    fi

    echo "✓ Configured to use $PROVIDER DNS (with priority over DHCP)"
fi

echo ""
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Call the restart-dns script
if [ -f "$SCRIPT_DIR/restart-dns.sh" ]; then
    "$SCRIPT_DIR/restart-dns.sh"
    if [ $? -ne 0 ]; then
        echo "Restoring backup..."
        sudo cp "$BACKUP_FILE" "$CONFIG_FILE"
        exit 1
    fi
else
    echo "Warning: restart-dns.sh not found, restarting manually..."
    sudo systemctl restart systemd-resolved
    if [ $? -ne 0 ]; then
        echo "✗ Failed to restart DNS resolver"
        echo "Restoring backup..."
        sudo cp "$BACKUP_FILE" "$CONFIG_FILE"
        exit 1
    fi
fi

echo ""
echo "You can test DNS resolution with: resolvectl query google.com"
