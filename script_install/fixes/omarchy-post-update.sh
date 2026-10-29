#!/usr/bin/env bash
# Recover task-planner after a mise Go upgrade. Safe to run repeatedly.
# Usage: bash omarchy-post-update.sh [--apply]
set -euo pipefail

apply=false
case "${1:-}" in
    '') ;;
    --apply) apply=true ;;
    *) echo "Usage: $0 [--apply]" >&2; exit 2 ;;
esac

destination="$HOME/.local/bin/task-planner"
if [[ -e "$destination" || -L "$destination" ]]; then
    if [[ -x "$destination" && ! -L "$destination" ]]; then
        echo "Already installed: $destination"
        exit 0
    fi
    echo "Refusing to overwrite existing file or symlink: $destination" >&2
    exit 1
fi

mise_data="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}"
shopt -s nullglob
candidates=("$mise_data"/installs/go/*/bin/task-planner)
if (( ${#candidates[@]} == 0 )); then
    echo "No installed task-planner binary found under $mise_data/installs/go" >&2
    exit 1
fi

# Pick the newest installed Go version that still contains the application.
source_binary=$(printf '%s\n' "${candidates[@]}" | sort -V | tail -n 1)
[[ -x "$source_binary" ]] || { echo "Not executable: $source_binary" >&2; exit 1; }
echo "Recover: $source_binary -> $destination"
if "$apply"; then
    mkdir -p -- "$(dirname -- "$destination")"
    # No overwrite if another process created the destination meanwhile.
    cp --no-clobber --preserve=mode -- "$source_binary" "$destination"
    echo 'Recovered. Open a new terminal to use the updated PATH and GOBIN.'
else
    echo 'Preview only. Pass --apply to copy the binary.'
fi
