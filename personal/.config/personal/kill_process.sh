#!/bin/bash
# Force kill processes by name
# The -9 flag sends a SIGKILL signal which force-terminates all processes immediately

killProcess() {
    local process_name="$1"

    if [[ -z "$process_name" ]]; then
        echo "Usage: killProcess <process-name>"
        echo "Example: killProcess brave"
        return 1
    fi

    # Check if process exists
    if ! pgrep -x "$process_name" >/dev/null; then
        echo "No process found matching: $process_name"
        return 1
    fi

    # Count processes before killing
    local count=$(pgrep -x "$process_name" | wc -l)

    # Kill all matching processes
    pkill -9 "$process_name"

    # Verify processes are killed
    sleep 0.2
    if ! pgrep -x "$process_name" >/dev/null; then
        echo "✓ Killed $count $process_name process(es)"
    else
        echo "Warning: Some $process_name processes may still be running"
        return 1
    fi
}
