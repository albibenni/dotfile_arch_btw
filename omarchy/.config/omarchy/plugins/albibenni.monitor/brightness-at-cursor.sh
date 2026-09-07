#!/usr/bin/env bash

set -euo pipefail

delta=${1:-0}
[[ $delta =~ ^-?[0-9]+$ ]] || exit 2
((delta != 0)) || exit 0

cursor_json=$(hyprctl cursorpos -j)
monitors_json=$(hyprctl monitors -j)

cursor_x=$(jq -r '.x' <<<"$cursor_json")
cursor_y=$(jq -r '.y' <<<"$cursor_json")

# Hyprland positions monitors in logical coordinates; mode dimensions must be
# divided by scale before testing which output contains the pointer.
monitor=$(jq -r --argjson cursor_x "$cursor_x" --argjson cursor_y "$cursor_y" '
  ([.[]
    | select(
        $cursor_x >= .x and $cursor_x < (.x + (.width / .scale)) and
        $cursor_y >= .y and $cursor_y < (.y + (.height / .scale))
      )][0].name)
  // ([.[] | select(.focused == true)][0].name)
  // empty
' <<<"$monitors_json")

[[ -n $monitor ]] || exit 1

if ((delta > 0)); then
  action="+${delta}%"
else
  action="${delta#-}%-"
fi

exec omarchy-brightness-display --no-osd --monitor "$monitor" "$action"
