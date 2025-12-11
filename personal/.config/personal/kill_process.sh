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

    # Show matching processes
    echo "Found $count process(es) matching '$process_name':"
    pgrep -x "$process_name" | while read -r pid; do
        ps -p "$pid" -o pid,comm,args --no-headers 2>/dev/null
    done

    # Ask for confirmation
    echo -n "Do you want to kill these processes? (y/N): "
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
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
    else
        echo "Cancelled - no processes were killed"
        return 0
    fi
}

killHyprlandWindow() {
    local search_term="$1"

    if [[ -z "$search_term" ]]; then
        echo "Usage: killHyprlandWindow <app-name>"
        echo "Example: killHyprlandWindow zoom"
        return 1
    fi

    # Get the address, class, and titles from hyprctl clients matching the search term
    # Search by class (application name) and use window address to close specific windows
    local results=$(hyprctl clients -j | jq -r ".[] | select(.class | test(\"$search_term\"; \"i\")) | \"\(.address)|\(.class)|\(.title)\"")

    if [[ -z "$results" ]]; then
        echo "No window found matching: $search_term"
        return 1
    fi

    # Convert to arrays
    local -a addresses
    local -a classes
    local -a titles
    local index=1
    while IFS='|' read -r address class title; do
        addresses+=("$address")
        classes+=("$class")
        titles+=("$title")
        echo "[$index] $class - $title"
        ((index++))
    done <<<"$results"

    local count=${#addresses[@]}

    # Ask which ones to kill
    if [[ $count -eq 1 ]]; then
        echo -n "Close this window? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Cancelled - no windows were closed"
            return 0
        fi
        selected_indices="1"
    else
        echo -n "Enter numbers to close (e.g., '1,3' or 'all') or 'n' to cancel: "
        read -r response

        if [[ "$response" =~ ^[Nn]$ ]] || [[ -z "$response" ]]; then
            echo "Cancelled - no windows were closed"
            return 0
        elif [[ "$response" == "all" ]]; then
            selected_indices=$(seq -s, 1 $count)
        else
            selected_indices="$response"
        fi
    fi

    # Close selected windows
    local closed_count=0
    local failed_windows=()

    IFS=',' read -ra indices <<<"$selected_indices"
    for idx in "${indices[@]}"; do
        # Trim whitespace
        idx=$(echo "$idx" | xargs)

        if [[ "$idx" =~ ^[0-9]+$ ]] && [[ $idx -ge 1 ]] && [[ $idx -le $count ]]; then
            local array_idx=$((idx - 1))
            local address="${addresses[$array_idx]}"

            if hyprctl dispatch closewindow address:$address >/dev/null 2>&1; then
                echo "✓ Closed window: ${classes[$array_idx]} - ${titles[$array_idx]}"
                ((closed_count++))
            else
                echo "✗ Failed to close window: ${classes[$array_idx]}"
                failed_windows+=("$address")
            fi
        else
            echo "Invalid selection: $idx"
        fi
    done

    if [[ $closed_count -gt 0 ]]; then
        echo "✓ Successfully closed $closed_count window(s)"
    fi

    if [[ ${#failed_windows[@]} -gt 0 ]]; then
        echo "Warning: Failed to close ${#failed_windows[@]} window(s)"
        return 1
    fi
}
