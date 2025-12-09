# Pacman Hooks for Atomic Updates

These hooks provide automatic snapshot creation and post-update cleanup.

## Installation

Copy hooks to system directory:
```bash
sudo cp *.hook /etc/pacman.d/hooks/
```

Or symlink them:
```bash
sudo ln -sf $(pwd)/00-pre-update-snapshot.hook /etc/pacman.d/hooks/
sudo ln -sf $(pwd)/99-post-update-cleanup.hook /etc/pacman.d/hooks/
```

## What They Do

### 00-pre-update-snapshot.hook
- Runs **before** any package upgrade
- Creates a btrfs snapshot using `system-snapshot-create.sh`
- Allows rollback if update breaks something

### 99-post-update-cleanup.hook
- Runs **after** package operations
- Clears update cache
- Runs custom post-update hooks

## Manual Installation Script

```bash
#!/bin/bash
# Install pacman hooks
cd "$(dirname "$0")"
sudo mkdir -p /etc/pacman.d/hooks/
sudo cp 00-pre-update-snapshot.hook /etc/pacman.d/hooks/
sudo cp 99-post-update-cleanup.hook /etc/pacman.d/hooks/
echo "✓ Pacman hooks installed"
```

## Disable Hooks Temporarily

To skip hooks for a single update:
```bash
sudo pacman -Syu --hookdir /dev/null
```
