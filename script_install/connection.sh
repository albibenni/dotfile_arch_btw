#!/bin/bash


# wifi ctl
# iwd -> sudo systemctl start iwd
sudo pacman -S iwd

# disable the default wpa_supplicant
# and enabling iwd to configure the connection
sudo systemctl stop wpa_supplicant@wlan0
sudo systemctl disable wpa_supplicant@wlan0
sudo systemctl enable iwd
sudo systemctl start iwd

# Create the /etc/iwd directory if it doesn't exist
sudo mkdir -p /etc/iwd

# Create or overwrite the main.conf file with the configuration
sudo tee /etc/iwd/main.conf > /dev/null << 'EOF'
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EnableIPv6=true
EOF

echo "iwd configuration file created at /etc/iwd/main.conf"

sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
echo "enabling systemd-resolved - check symlink"

sudo systemctl stop iwd
sudo systemctl start iwd

# to connect follow the steps:
# 1. iwctl
# 2. station list
# 3. station wlan0 get-networks
# 4. station wlan0 connect <network name>
# 4.1. enter password
# 5 exit

## possible solutions - intermittent disconnecitons
# ➜  ~ sudo mkdir -p /etc/NetworkManager/conf.d/
# [sudo] password for benni:
# ➜  ~ echo -e '[main]\ndns-timeout=10' | sudo tee /etc/NetworkManager/conf.d/dns-timeout.conf
# [main]
# dns-timeout=10
# ➜  ~ sudo systemctl reload NetworkManager
# ➜  ~ sudo chattr +i /etc/resolv.conf
# # 3. Add fallback DNS to NetworkManager config:
# bashecho -e '[global-dns-domain-*]\nservers=8.8.8.8,8.8.4.4,1.1.1.1' | sudo tee /etc/NetworkManager/conf.d/dns-servers.conf
# sudo systemctl reload NetworkManager
# # Clear any DNS cache
# sudo systemctl flush-dns 2>/dev/null || true
