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
EOF

echo "iwd configuration file created at /etc/iwd/main.conf"

sudo systemctl stop iwd
sudo systemctl start iwd

# to connect follow the steps:
# 1. iwctl
# 2. station list
# 3. station wlan0 get-networks
# 4. station wlan0 connect <network name>
# 4.1. enter password
# 5 exit
