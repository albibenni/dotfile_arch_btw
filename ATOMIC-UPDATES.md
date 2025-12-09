# Atomic Updates System

A complete update system for clean Arch Linux, inspired by Omarchy's update mechanism.

## Features

✅ **Automatic btrfs snapshots** before updates
✅ **Pre/post-update pacman hooks**
✅ **Migration system** for one-time setup tasks
✅ **Waybar notification** when updates available
✅ **Easy rollback** if something breaks
✅ **Safe and atomic** update process

---

## Quick Start

### 1. Install the System

```bash
cd ~/dotfiles
./script_install/fresh_install/install-system-hooks.sh
```

This installs pacman hooks that automatically create snapshots before package updates.

### 2. Configure Waybar (for clean Arch)

In `waybar/.config/waybar/modules.jsonc`, comment out the Omarchy section and uncomment the clean Arch section:

```jsonc
// Omarchy update (for Omarchy-based systems)
// "custom/update": {
//   "format": "",
//   "exec": "omarchy-update-available",
//   ...
// },

// Clean Arch update (uncomment for non-Omarchy systems)
"custom/update": {
  "format": "{}",
  "exec": "system-update-available.sh",
  "on-click": "launch-floating-terminal-with-presentation.sh system-update.sh",
  "tooltip-format": "System update available",
  "signal": 7,
  "interval": 3600
},
```

### 3. Update Your System

```bash
system-update.sh
```

---

## Commands

### Update System
```bash
system-update.sh
```

Performs a full system update with:
1. Check for available updates
2. Create pre-update snapshot
3. Update packages with `pacman -Syu`
4. Run migrations
5. Run post-update hooks
6. Refresh waybar indicator

### Create Snapshot
```bash
system-snapshot-create.sh "My snapshot description"
```

Creates a manual snapshot before making changes.

### Restore Snapshot
```bash
system-snapshot-restore.sh
```

Interactive menu to restore from a previous snapshot.

### Check for Updates
```bash
system-update-available.sh
```

Checks if updates are available (used by waybar).

### Run Migrations
```bash
system-migrate.sh
```

Manually run pending migrations.

---

## How It Works

### 1. Automatic Snapshots (Pacman Hooks)

**Before Updates**: `00-pre-update-snapshot.hook`
```
pacman -Syu
  ↓
[HOOK] Create snapshot
  ↓
Download & install packages
```

**After Updates**: `99-post-update-cleanup.hook`
```
Packages installed
  ↓
[HOOK] Clear update cache
  ↓
[HOOK] Run post-update tasks
```

### 2. Snapshot System

**Using Snapper** (if configured):
- Creates numbered snapshots
- Automatic cleanup (keeps last 10)
- Full btrfs snapshot capability

**Fallback** (no snapper):
- Backs up `~/.config` and `~/.local/share/bin`
- Timestamped backups: `manual-YYYYMMDD-HHMMSS`
- Keeps last 10 backups

### 3. Migration System

Similar to Omarchy's `omarchy-migrate`:

**Migration Files**: `~/.config/personal/migrations/*.sh`

**Naming**: Use Unix timestamps
```bash
1733762400-restore-symlinks.sh
1733762500-update-config.sh
```

**State Tracking**: `~/.local/state/migrations/`
- Completed: `1733762400-restore-symlinks.sh` (empty file)
- Skipped: `skipped/1733762400-restore-symlinks.sh`

**Execution**:
- Runs in order (timestamp-sorted)
- Skips already-completed migrations
- Asks to skip if migration fails

### 4. Update Notification

Waybar module checks every hour:
- **Icon** when updates available
- **Empty** when up to date
- Click to run `system-update.sh`

---

## File Locations

### Scripts
```
exec_scripts/.local/share/bin/
├── system-update.sh              # Main update command
├── system-snapshot-create.sh     # Create snapshot
├── system-snapshot-restore.sh    # Restore snapshot
├── system-update-available.sh    # Check for updates
└── system-migrate.sh             # Run migrations
```

### Hooks
```
script_install/system-hooks/
├── 00-pre-update-snapshot.hook   # Pre-update snapshot
├── 99-post-update-cleanup.hook   # Post-update cleanup
└── README.md                     # Hooks documentation
```

### Migrations
```
personal/.config/personal/migrations/
├── README.md                     # Migration guide
├── example-*.sh.disabled         # Example migrations
└── 1733762400-*.sh              # Active migrations
```

### State
```
~/.local/state/
├── snapshots/
│   ├── snapshot.log             # Snapshot history
│   ├── last-snapshot            # Last snapshot number
│   └── manual-*/                # Manual backups (no snapper)
└── migrations/
    ├── 1733762400-*.sh          # Completed migrations
    └── skipped/                 # Skipped migrations
```

---

## Example Usage

### Fresh Install Setup

```bash
# 1. Clone dotfiles
cd ~/dotfiles

# 2. Install pacman hooks
./script_install/fresh_install/install-system-hooks.sh

# 3. Configure waybar for clean Arch
# Edit waybar/.config/waybar/modules.jsonc
# Comment Omarchy, uncomment Clean Arch section

# 4. Restore symlinks
source personal/.config/personal/restore-symlinks.sh
restore-symlinks

# 5. First update
system-update.sh
```

### Regular Updates

```bash
# Just run the update command
system-update.sh
```

### After Breaking Something

```bash
# Restore from snapshot
system-snapshot-restore.sh

# Select snapshot number when prompted
# Reboot to apply
```

### Creating a Migration

```bash
# Create migration file
TIMESTAMP=$(date +%s)
vim ~/.config/personal/migrations/${TIMESTAMP}-my-migration.sh

# Make it executable
chmod +x ~/.config/personal/migrations/${TIMESTAMP}-my-migration.sh

# Test it
bash ~/.config/personal/migrations/${TIMESTAMP}-my-migration.sh

# It will run automatically on next update
```

---

## Comparison: Omarchy vs This System

| Feature | Omarchy | This System |
|---------|---------|-------------|
| **Snapshots** | omarchy-snapshot | system-snapshot-create.sh |
| **Update** | omarchy-update | system-update.sh |
| **Migrations** | ~/.local/share/omarchy/migrations/ | ~/.config/personal/migrations/ |
| **Hooks** | Built-in | Pacman hooks |
| **Configs** | Copy from ~/.local/share/omarchy/config/ | Symlink from dotfiles |
| **Notification** | omarchy-update-available | system-update-available.sh |
| **Git tracking** | Omarchy repo | Your dotfiles repo |

---

## Tips

### Disable Hooks Temporarily
```bash
# Skip all hooks for one update
sudo pacman -Syu --hookdir /dev/null
```

### Manual Snapshot Before Risky Change
```bash
system-snapshot-create.sh "Before installing AUR package"
# ... do risky thing ...
```

### View Snapshot Log
```bash
cat ~/.local/state/snapshots/snapshot.log
```

### List All Migrations
```bash
ls -1 ~/.config/personal/migrations/*.sh
```

### Check Migration Status
```bash
# Completed
ls ~/.local/state/migrations/

# Skipped
ls ~/.local/state/migrations/skipped/
```

---

## Troubleshooting

### Snapshots Not Creating

**Check snapper configuration:**
```bash
snapper list
# If error, snapper is not configured
```

**Fallback to manual backups:**
The system automatically falls back to backing up `~/.config` if snapper isn't available.

### Hooks Not Running

**Verify hooks are installed:**
```bash
ls -l /etc/pacman.d/hooks/
# Should show:
# 00-pre-update-snapshot.hook
# 99-post-update-cleanup.hook
```

**Reinstall hooks:**
```bash
cd ~/dotfiles
./script_install/fresh_install/install-system-hooks.sh
```

### Migration Failed

Migrations that fail will prompt you to skip. To re-run a skipped migration:

```bash
# Remove from skipped
rm ~/.local/state/migrations/skipped/1733762400-*.sh

# Run migrations again
system-migrate.sh
```

---

## Security Note

The pacman hooks run as root but execute user scripts with `sudo -u albibenni`. Make sure your scripts are secure and don't accept untrusted input.

---

**Created**: 2024-12-09
**Compatible with**: Arch Linux, btrfs filesystems
**Inspired by**: Omarchy by DHH
