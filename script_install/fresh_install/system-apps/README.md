# System Apps Installation Scripts

Scripts for installing system packages on fresh Arch installations.

## Available Scripts

### `atomic-updates.sh`
Installs packages required for the atomic update system:
- **snapper** - Btrfs snapshot management
- **btrfs-progs** - Btrfs filesystem tools
- **pacman-contrib** - Provides `checkupdates` command

**Usage:**
```bash
bash atomic-updates.sh
```

### `utils.sh`
Installs essential development and utility tools:
- base-devel, cmake, man-db, stow, clang, ripgrep, neofetch

**Usage:**
```bash
bash utils.sh
```

### `benni-menu-deps.sh`
Dependencies for benni-menu launcher.

### `eleph_wlaker.sh`
Elephant and Walker installation.

### `network.sh`
Network management tools.

### `waybar.sh`
Waybar status bar installation.

## Installation Order (Fresh Install)

1. **System apps** (this directory)
   ```bash
   bash utils.sh
   bash atomic-updates.sh
   bash waybar.sh
   # etc...
   ```

2. **Pacman hooks**
   ```bash
   bash ../install-system-hooks.sh
   ```

3. **Restore symlinks**
   ```bash
   source ~/dotfiles/personal/.config/personal/restore-symlinks.sh
   restore-symlinks
   ```

4. **First update**
   ```bash
   system-update.sh
   ```
