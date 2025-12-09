#!/bin/bash

# Run tte in a loop in background
(
  while true; do
    clear
    tte --input-file "$HOME/.local/share/arch/logo.txt" \
        --canvas-width 0 \
        --canvas-height 0 \
        --anchor-canvas c \
        --anchor-text c \
        --random-effect
    sleep 1
  done
) &

loop_pid=$!

# Wait for any keypress
read -n 1 -s

# Kill the loop when key is pressed
kill $loop_pid 2>/dev/null
pkill -P $loop_pid 2>/dev/null
