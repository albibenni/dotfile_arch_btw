#!/usr/bin/env bash
# Create a btrfs snapshot before system updates

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SNAPSHOT_DIR="$HOME/.local/state/snapshots"
SNAPSHOT_LOG="$SNAPSHOT_DIR/snapshot.log"
MAX_SNAPSHOTS=10

# Ensure state directory exists
mkdir -p "$SNAPSHOT_DIR"

# Check if snapper is configured
if ! snapper list &>/dev/null; then
    echo -e "${YELLOW}⚠ Snapper not configured. Using manual backup instead.${NC}" | tee -a "$SNAPSHOT_LOG"

    # Fallback: backup critical dotfiles
    BACKUP_DIR="$SNAPSHOT_DIR/manual-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    # Backup critical files
    cp -a ~/.config "$BACKUP_DIR/" 2>/dev/null || true
    cp -a ~/.local/share/bin "$BACKUP_DIR/" 2>/dev/null || true

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Manual backup created: $BACKUP_DIR" | tee -a "$SNAPSHOT_LOG"

    # Cleanup old manual backups
    ls -dt "$SNAPSHOT_DIR"/manual-* 2>/dev/null | tail -n +$((MAX_SNAPSHOTS + 1)) | xargs rm -rf 2>/dev/null || true

    exit 0
fi

# Create snapper snapshot
DESCRIPTION="${1:-Pre-update snapshot}"

echo -e "${BLUE}Creating snapshot...${NC}"

if SNAPSHOT_NUM=$(snapper create --type=pre --cleanup-algorithm=number --print-number --description="$DESCRIPTION" 2>&1); then
    echo -e "${GREEN}✓ Snapshot #$SNAPSHOT_NUM created successfully${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Snapshot #$SNAPSHOT_NUM: $DESCRIPTION" >> "$SNAPSHOT_LOG"
    echo "$SNAPSHOT_NUM" > "$SNAPSHOT_DIR/last-snapshot"
    exit 0
else
    echo -e "${RED}✗ Failed to create snapshot${NC}" >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Failed to create snapshot" >> "$SNAPSHOT_LOG"
    exit 1
fi
