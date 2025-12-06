# Sky Go on Arch Linux - Windows VM Setup

This folder contains scripts to set up a Windows 11 virtual machine for running Sky Go on Arch Linux.

## Why a Windows VM?

Sky Go does not support Linux natively due to DRM restrictions. Running Windows in a VM using QEMU/KVM is the most reliable way to use Sky Go on Linux.

## Prerequisites

- AMD-V or Intel VT-x virtualization support (already verified on your system)
- At least 8GB RAM (4GB for VM, 4GB for host)
- At least 60GB free disk space for Windows VM
- Internet connection to download Windows ISO
- TPM 2.0 emulation (swtpm) - installed automatically by the setup scripts

## Installation Steps

Run these scripts **in order**:

### 1. Install Packages
```bash
./01-install-packages.sh
```
Installs QEMU, KVM, virt-manager, and related packages.

### 2. Setup libvirt
```bash
./02-setup-libvirt.sh
```
Enables the libvirt service and adds your user to the libvirt group.

**IMPORTANT:** After this step, log out and log back in for group changes to take effect!

### 3. Download Windows ISO
```bash
./03-download-windows.sh
```
Provides instructions for downloading Windows 11 ISO and verifies the download.

### 4. Create VM
```bash
./04-create-vm.sh
```
Launches virt-manager and provides step-by-step instructions for creating the Windows VM.

## After VM Creation

1. Complete Windows 11 installation in the VM
2. Sign in with a Microsoft account or create a local account
3. Install Sky Go:
   - Option A: Download from Microsoft Store
   - Option B: Download from Sky website (https://www.sky.com/help/articles/download-sky-go)
4. Sign in to Sky Go and enjoy your content!

## VM Management

- **Start VM**: Open virt-manager and click the play button on your VM
- **Stop VM**: Shut down Windows normally from within the VM
- **Delete VM**: Right-click VM in virt-manager → Delete

## Troubleshooting

### Windows 11 installation says "This PC can't run Windows 11"
- Make sure you enabled TPM 2.0 during VM creation (see step 9-14 in 04-create-vm.sh)
- Make sure you selected UEFI firmware (see step 15-17 in 04-create-vm.sh)
- If you already created the VM, you can add TPM by:
  1. Shut down the VM
  2. Open VM details in virt-manager
  3. Click "Add Hardware" → "TPM"
  4. Set Type: Emulated, Model: TIS, Version: 2.0
  5. Change firmware to UEFI in Overview settings

### VM is slow
- Allocate more CPU cores (2-4 recommended)
- Allocate more RAM (6-8GB recommended if you have enough)
- Enable 3D acceleration in VM settings

### Sky Go won't install or run
- Make sure Windows is fully updated (Windows Update)
- Check if your Sky Go subscription is active
- Try installing from the Microsoft Store instead of Sky website (or vice versa)

### Can't access VM network
- Check that libvirtd service is running: `systemctl status libvirtd`
- Check VM network settings in virt-manager (should be NAT by default)

## Performance Tips

- Use virtio drivers for better disk and network performance
- Enable CPU host-passthrough in VM settings for better CPU performance
- Consider using UEFI instead of BIOS for the VM

## Alternative Methods (Not Recommended)

We tried to use Wine or Android emulation, but these methods don't work reliably with Sky Go due to DRM restrictions. The Windows VM approach is currently the most reliable solution.
