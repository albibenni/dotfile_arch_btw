#!/usr/bin/env bash
# Check if system updates are available

set -euo pipefail

CACHE_FILE="$HOME/.cache/system-update-available"
CACHE_DIR=$(dirname "$CACHE_FILE")

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Check if we should update the cache (every hour)
if [ -f "$CACHE_FILE" ]; then
    CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [ $CACHE_AGE -lt 3600 ]; then
        # Cache is fresh, use it
        cat "$CACHE_FILE" 2>/dev/null || echo ""
        exit 0
    fi
fi

# Check for updates (silently)
if checkupdates &>/dev/null; then
    UPDATE_COUNT=$(checkupdates 2>/dev/null | wc -l)

    if [ "$UPDATE_COUNT" -gt 0 ]; then
        echo "" > "$CACHE_FILE"  # Output icon
        echo ""
    else
        echo "" > "$CACHE_FILE"
        echo ""
    fi
else
    # No updates or error
    echo "" > "$CACHE_FILE"
    echo ""
fi
