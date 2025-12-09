#!/usr/bin/env bash
# Migration system - similar to Omarchy's omarchy-migrate

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Where we store migrations and their state
MIGRATIONS_DIR="$HOME/.config/personal/migrations"
STATE_DIR="$HOME/.local/state/migrations"
SKIPPED_DIR="$STATE_DIR/skipped"

# Ensure directories exist
mkdir -p "$MIGRATIONS_DIR"
mkdir -p "$STATE_DIR"
mkdir -p "$SKIPPED_DIR"

# Check if there are any migrations to run
if [ ! -d "$MIGRATIONS_DIR" ] || [ -z "$(ls -A "$MIGRATIONS_DIR"/*.sh 2>/dev/null)" ]; then
    echo -e "${BLUE}No migrations to run${NC}"
    exit 0
fi

# Run any pending migrations
MIGRATIONS_RUN=0

for migration_file in "$MIGRATIONS_DIR"/*.sh; do
    [ -f "$migration_file" ] || continue

    filename=$(basename "$migration_file")
    migration_name="${filename%.sh}"

    # Skip if already run or skipped
    if [ -f "$STATE_DIR/$filename" ]; then
        continue
    fi

    if [ -f "$SKIPPED_DIR/$filename" ]; then
        continue
    fi

    # Run migration
    echo -e "${GREEN}Running migration: ${migration_name}${NC}"
    MIGRATIONS_RUN=$((MIGRATIONS_RUN + 1))

    if bash "$migration_file"; then
        # Mark as complete
        touch "$STATE_DIR/$filename"
        echo -e "${GREEN}✓ Migration completed: ${migration_name}${NC}\n"
    else
        # Migration failed
        echo -e "${RED}✗ Migration failed: ${migration_name}${NC}"

        # Ask if we should skip it
        read -p "Skip this migration and continue? [y/N] " -n 1 -r SKIP
        echo ""

        if [[ $SKIP =~ ^[Yy]$ ]]; then
            touch "$SKIPPED_DIR/$filename"
            echo -e "${YELLOW}⚠ Migration skipped${NC}\n"
        else
            echo -e "${RED}Aborting migrations${NC}"
            exit 1
        fi
    fi
done

if [ $MIGRATIONS_RUN -eq 0 ]; then
    echo -e "${BLUE}All migrations up to date${NC}"
else
    echo -e "${GREEN}✓ Completed $MIGRATIONS_RUN migration(s)${NC}"
fi
