#!/usr/bin/env bash
# Restore from a btrfs snapshot

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SNAPSHOT_DIR="$HOME/.local/state/snapshots"

# Check if snapper is available
if ! command -v snapper &>/dev/null; then
    echo -e "${RED}✗ Snapper not installed${NC}"

    # Show manual backups
    if [ -d "$SNAPSHOT_DIR" ]; then
        echo -e "\n${BLUE}Available manual backups:${NC}"
        ls -dt "$SNAPSHOT_DIR"/manual-* 2>/dev/null | while read -r backup; do
            echo "  $(basename "$backup")"
        done
        echo -e "\n${YELLOW}To restore manually, copy files from:${NC}"
        echo "  $SNAPSHOT_DIR/manual-YYYYMMDD-HHMMSS/"
    fi
    exit 1
fi

# Show available snapshots
echo -e "${BLUE}Available snapshots:${NC}"
snapper list

echo ""
read -p "Enter snapshot number to restore (or 'q' to quit): " SNAPSHOT_NUM

if [[ "$SNAPSHOT_NUM" == "q" ]]; then
    exit 0
fi

echo -e "${YELLOW}⚠ WARNING: This will restore your system to snapshot #$SNAPSHOT_NUM${NC}"
echo -e "${YELLOW}⚠ Current state will be lost unless you create a snapshot first${NC}"
echo ""
read -p "Are you sure? Type 'yes' to continue: " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo -e "${BLUE}Restoring snapshot #$SNAPSHOT_NUM...${NC}"

if snapper --ambit classic rollback "$SNAPSHOT_NUM"; then
    echo -e "${GREEN}✓ Snapshot restored successfully${NC}"
    echo -e "${YELLOW}⚠ Reboot required to apply changes${NC}"
else
    echo -e "${RED}✗ Failed to restore snapshot${NC}"
    exit 1
fi
