#!/bin/bash
# Create Windows 11 VM using virt-manager

set -e

echo "=== Creating Windows 11 VM ==="
echo ""

# Check if ISO path was saved
if [ -f /tmp/windows-iso-path.txt ]; then
    ISO_PATH=$(cat /tmp/windows-iso-path.txt)
    echo "Using ISO: $ISO_PATH"
else
    echo "Enter the full path to your Windows 11 ISO file:"
    read -r ISO_PATH

    if [ ! -f "$ISO_PATH" ]; then
        echo "✗ ISO file not found at: $ISO_PATH"
        exit 1
    fi
fi

echo ""
echo "Opening virt-manager to create the VM..."
echo ""
echo "VM Creation Steps in virt-manager:"
echo "1. Click 'Create a new virtual machine'"
echo "2. Select 'Local install media' and click Forward"
echo "3. Click 'Browse...' and navigate to: $ISO_PATH"
echo "4. OS detection should show 'Microsoft Windows 11' - click Forward"
echo "5. Allocate memory (4096 MB minimum) and CPUs (2 minimum) - click Forward"
echo "6. Allocate disk space (60 GB minimum) - click Forward"
echo "7. Name your VM (e.g., 'Windows-SkyGo')"
echo "8. IMPORTANT: Check 'Customize configuration before install' - click Finish"
echo ""
echo "CRITICAL: Configure Network Adapter (Required for Internet Access):"
echo "9. In the VM configuration window, click 'NIC ...' in the left sidebar"
echo "10. Under 'Device model', change from 'virtio' to 'e1000' or 'e1000e'"
echo "11. Click 'Apply'"
echo ""
echo "CRITICAL: Configure TPM 2.0 (Required for Windows 11):"
echo "12. Click 'Add Hardware'"
echo "13. Select 'TPM' from the left sidebar"
echo "14. Set Type to 'Emulated'"
echo "15. Set Model to 'TIS' (or 'CRB' if available)"
echo "16. Set Version to '2.0'"
echo "17. Click 'Finish' to add the TPM"
echo ""
echo "Configure UEFI (Required for TPM and Windows 11):"
echo "18. Click 'Overview' in the left sidebar"
echo "19. Under 'Firmware', select 'UEFI x86_64: /usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd'"
echo "20. Click 'Apply'"
echo "21. Click 'Begin Installation' at the top left"
echo "22. The VM will start and Windows installation will begin"
echo ""
echo "Windows Installation:"
echo "- Follow the Windows 11 setup wizard"
echo "- Choose your language and keyboard"
echo "- Click 'Install now'"
echo "- Select 'I don't have a product key' (you can activate later)"
echo "- Choose Windows 11 Home or Pro"
echo "- Accept license terms"
echo "- Select 'Custom: Install Windows only'"
echo "- Select the virtual disk and click Next"
echo "- Wait for installation to complete"
echo ""
echo "After Windows is installed:"
echo "- Complete the Windows setup (create user account, etc.)"
echo "- Install Sky Go from the Windows Store or Sky website"
echo ""

# Launch virt-manager
virt-manager &

echo "virt-manager has been launched!"
