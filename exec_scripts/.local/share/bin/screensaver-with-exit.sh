#!/bin/bash

# Run tte in background
tte --input-file "$HOME/.local/share/arch/logo.txt" \
    --canvas-width 0 \
    --canvas-height 0 \
    --anchor-canvas c \
    --anchor-text c \
    --random-effect &

tte_pid=$!

# Wait for any keypress
read -n 1 -s

# Kill tte when key is pressed
kill $tte_pid 2>/dev/null
