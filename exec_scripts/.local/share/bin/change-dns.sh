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

# Configure systemd-networkd to ignore/accept DHCP DNS based on choice
NETWORKD_WLAN="/etc/systemd/network/20-wlan.network"
if [ -f "$NETWORKD_WLAN" ]; then
    if [ -z "$DNS_SERVERS" ]; then
        # Router option - set UseDNS=yes to accept DHCP/RA DNS
        # Handle [DHCPv4] section
        if grep -q "^\[DHCPv4\]" "$NETWORKD_WLAN"; then
            if grep -A 20 "^\[DHCPv4\]" "$NETWORKD_WLAN" | grep -q "^UseDNS="; then
                sudo sed -i '/^\[DHCPv4\]/,/^\[/ s/^UseDNS=.*/UseDNS=yes/' "$NETWORKD_WLAN"
            else
                sudo sed -i "/^\[DHCPv4\]/a UseDNS=yes" "$NETWORKD_WLAN"
            fi
            NETWORKD_CHANGED=1
        fi

        # Handle [IPv6AcceptRA] section
        if grep -q "^\[IPv6AcceptRA\]" "$NETWORKD_WLAN"; then
            if grep -A 20 "^\[IPv6AcceptRA\]" "$NETWORKD_WLAN" | grep -q "^UseDNS="; then
                sudo sed -i '/^\[IPv6AcceptRA\]/,/^\[/ s/^UseDNS=.*/UseDNS=yes/' "$NETWORKD_WLAN"
            else
                sudo sed -i "/^\[IPv6AcceptRA\]/a UseDNS=yes" "$NETWORKD_WLAN"
            fi
            NETWORKD_CHANGED=1
        fi

        if [ -n "$NETWORKD_CHANGED" ]; then
            echo "✓ Configured networkd to accept DHCP/RA DNS (IPv4 and IPv6)"
        fi
    else
        # Public DNS option - set UseDNS=no to ignore DHCP/RA DNS
        # Handle [DHCPv4] section
        if grep -q "^\[DHCPv4\]" "$NETWORKD_WLAN"; then
            if grep -A 20 "^\[DHCPv4\]" "$NETWORKD_WLAN" | grep -q "^UseDNS="; then
                sudo sed -i '/^\[DHCPv4\]/,/^\[/ s/^UseDNS=.*/UseDNS=no/' "$NETWORKD_WLAN"
            else
                sudo sed -i "/^\[DHCPv4\]/a UseDNS=no" "$NETWORKD_WLAN"
            fi
            NETWORKD_CHANGED=1
        else
            # Create [DHCPv4] section if it doesn't exist
            echo -e "\n[DHCPv4]\nUseDNS=no" | sudo tee -a "$NETWORKD_WLAN" >/dev/null
            NETWORKD_CHANGED=1
        fi

        # Handle [IPv6AcceptRA] section
        if grep -q "^\[IPv6AcceptRA\]" "$NETWORKD_WLAN"; then
            if grep -A 20 "^\[IPv6AcceptRA\]" "$NETWORKD_WLAN" | grep -q "^UseDNS="; then
                sudo sed -i '/^\[IPv6AcceptRA\]/,/^\[/ s/^UseDNS=.*/UseDNS=no/' "$NETWORKD_WLAN"
            else
                sudo sed -i "/^\[IPv6AcceptRA\]/a UseDNS=no" "$NETWORKD_WLAN"
            fi
            NETWORKD_CHANGED=1
        else
            # Create [IPv6AcceptRA] section if it doesn't exist
            echo -e "\n[IPv6AcceptRA]\nUseDNS=no" | sudo tee -a "$NETWORKD_WLAN" >/dev/null
            NETWORKD_CHANGED=1
        fi

        if [ -n "$NETWORKD_CHANGED" ]; then
            echo "✓ Configured networkd to ignore DHCP/RA DNS (IPv4 and IPv6)"
        fi
    fi
fi

# Restart systemd-networkd only if we made changes
if [ -n "$NETWORKD_CHANGED" ]; then
    echo "Restarting systemd-networkd..."
    sudo systemctl restart systemd-networkd
    if [ $? -ne 0 ]; then
        echo "✗ Failed to restart systemd-networkd"
        exit 1
    fi
    sleep 1
fi

echo ""

# Call the restart-dns script
if command -v restart-dns.sh &>/dev/null; then
    restart-dns.sh
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

global_dns=$(resolvectl status | awk '/^Global/,/^$/ {if (/^$/) exit; print}')
echo "$global_dns"

echo ""
echo "You can test DNS resolution with: resolvectl query google.com"
