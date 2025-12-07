#!/bin/bash

STATE_DIR="$HOME/.local/state/benni/"
mkdir -p "$STATE_DIR"

COMMAND="$1"
STATE_NAME="$2"

if [[ -z "$COMMAND" ]]; then
    echo "Usage: benni-state <set|clear> <state-name-or-pattern>"
    exit 1
fi

if [[ -z "$STATE_NAME" ]]; then
    echo "Usage: benni-state $COMMAND <state-name>"
    exit 1
fi

case "$COMMAND" in
set) touch "$STATE_DIR/$STATE_NAME" ;;
clear) find "$STATE_DIR" -maxdepth 1 -type f -name "$STATE_NAME" -delete ;;
esac
