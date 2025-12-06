#!/bin/bash
# Install QEMU/KVM and virtualization packages for Sky Go VM

set -e

echo "=== Installing QEMU/KVM and virtualization packages ==="

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "Please run as normal user (will use sudo when needed)"
   exit 1
fi

# Install required packages
sudo pacman -S --needed \
    qemu-full \
    virt-manager \
    libvirt \
    dnsmasq \
    iptables-nft \
    edk2-ovmf \
    swtpm

echo ""
echo "✓ Packages installed successfully!"
echo "Next step: Run 02-setup-libvirt.sh"
