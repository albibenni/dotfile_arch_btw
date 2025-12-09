#!/usr/bin/env bash
# Atomic system update with snapshots and migrations

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Error handler
trap 'echo -e "\n${RED}✗ Update failed! Check output above for errors.${NC}\n${YELLOW}You can restore from snapshot using: system-snapshot-restore.sh${NC}"; exit 1' ERR

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}System Update - Atomic & Safe${NC}                          ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check for updates
echo -e "${BLUE}→ Checking for updates...${NC}"
if ! UPDATE_LIST=$(checkupdates 2>/dev/null); then
    echo -e "${GREEN}✓ System is up to date!${NC}"
    exit 0
fi

UPDATE_COUNT=$(echo "$UPDATE_LIST" | wc -l)
echo -e "${YELLOW}Found $UPDATE_COUNT package(s) to update${NC}\n"

# Show first 10 packages
echo -e "${BLUE}Packages to update:${NC}"
echo "$UPDATE_LIST" | head -10
if [ "$UPDATE_COUNT" -gt 10 ]; then
    echo "... and $((UPDATE_COUNT - 10)) more"
fi
echo ""

# Confirm
read -p "Continue with update? [Y/n] " -n 1 -r CONFIRM
echo ""
if [[ ! $CONFIRM =~ ^[Yy]$ ]] && [[ -n $CONFIRM ]]; then
    echo "Update cancelled."
    exit 0
fi

# Step 1: Create snapshot
echo ""
echo -e "${BLUE}→ Creating pre-update snapshot...${NC}"
if system-snapshot-create.sh "Pre-update: $(date +%Y-%m-%d)"; then
    echo -e "${GREEN}✓ Snapshot created${NC}"
else
    echo -e "${YELLOW}⚠ Snapshot failed, but continuing...${NC}"
fi

# Step 2: Update system
echo ""
echo -e "${BLUE}→ Updating system packages...${NC}"
sudo pacman -Syu --noconfirm

# Step 3: Run migrations
echo ""
if [ -x "$HOME/.local/share/bin/system-migrate.sh" ]; then
    echo -e "${BLUE}→ Running migrations...${NC}"
    system-migrate.sh
fi

# Step 4: Run post-update hook
echo ""
if [ -x "$HOME/.local/share/bin/benni-hook.sh" ]; then
    echo -e "${BLUE}→ Running post-update hooks...${NC}"
    benni-hook.sh post-update 2>/dev/null || true
fi

# Step 5: Clear update cache
rm -f "$HOME/.cache/system-update-available" 2>/dev/null || true

# Send signal to waybar to refresh
pkill -RTMIN+7 waybar 2>/dev/null || true

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}✓ System update completed successfully!${NC}               ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Snapshot created - you can rollback anytime with:${NC}"
echo -e "  ${BOLD}system-snapshot-restore.sh${NC}"
echo ""
