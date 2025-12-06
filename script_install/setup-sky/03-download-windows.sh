#!/bin/bash
# Download Windows 11 ISO

set -e

echo "=== Windows 11 ISO Download Guide ==="
echo ""
echo "You need to download a Windows 11 ISO file. Here are your options:"
echo ""
echo "Option 1: Official Microsoft ISO (Recommended)"
echo "  Visit: https://www.microsoft.com/software-download/windows11"
echo "  - Select 'Download Windows 11 Disk Image (ISO)'"
echo "  - Choose your language"
echo "  - Download the 64-bit ISO"
echo ""
echo "Option 2: Use a third-party downloader"
echo "  You can use tools like 'mist-cli' from AUR to download Windows ISOs"
echo ""
echo "Recommended download location: ~/Downloads/"
echo ""
echo "After downloading, note the path to your ISO file."
echo "You'll need it for the next step (04-create-vm.sh)"
echo ""
echo "Press Enter when you've downloaded the Windows 11 ISO..."
read -r

echo ""
echo "Enter the full path to your Windows 11 ISO file:"
echo "(e.g., /home/$USER/Downloads/Win11_English_x64.iso)"
read -r ISO_PATH

if [ -f "$ISO_PATH" ]; then
    echo "✓ ISO file found: $ISO_PATH"
    echo "$ISO_PATH" > /tmp/windows-iso-path.txt
    echo ""
    echo "Next step: Run 04-create-vm.sh"
else
    echo "✗ ISO file not found at: $ISO_PATH"
    echo "Please check the path and try again"
    exit 1
fi
