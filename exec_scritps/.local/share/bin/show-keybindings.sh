#!/bin/bash

# Custom keybindings reference menu based on omarchy-menu-keybindings
# Shows both Hyprland and Bash/Terminal keybindings using walker

declare -A KEYCODE_SYM_MAP

build_keymap_cache() {
  local keymap
  keymap="$(xkbcli compile-keymap)" || {
    echo "Failed to compile keymap" >&2
    return 1
  }

  while IFS=, read -r code sym; do
    [[ -z "$code" || -z "$sym" ]] && continue
    KEYCODE_SYM_MAP["$code"]="$sym"
  done < <(
    awk '
      BEGIN { sec = "" }
      /xkb_keycodes/ { sec = "codes"; next }
      /xkb_symbols/  { sec = "syms";  next }
      sec == "codes" {
        if (match($0, /<([A-Za-z0-9_]+)>\s*=\s*([0-9]+)\s*;/, m)) code_by_name[m[1]] = m[2]
      }
      sec == "syms" {
        if (match($0, /key\s*<([A-Za-z0-9_]+)>\s*\{\s*\[\s*([^, \]]+)/, m)) sym_by_name[m[1]] = m[2]
      }
      END {
        for (k in code_by_name) {
          c = code_by_name[k]
          s = sym_by_name[k]
          if (c != "" && s != "" && s != "NoSymbol") print c "," s
        }
      }
    ' <<<"$keymap"
  )
}

lookup_keycode_cached() {
  printf '%s\n' "${KEYCODE_SYM_MAP[$1]}"
}

parse_keycodes() {
  while IFS= read -r line; do
    if [[ "$line" =~ code:([0-9]+) ]]; then
      code="${BASH_REMATCH[1]}"
      symbol=$(lookup_keycode_cached "$code")
      echo "${line/code:${code}/$symbol}"
    elif [[ "$line" =~ mouse:([0-9]+) ]]; then
      code="${BASH_REMATCH[1]}"
      case "$code" in
        272) symbol="LEFT MOUSE BUTTON" ;;
        273) symbol="RIGHT MOUSE BUTTON" ;;
        274) symbol="MIDDLE MOUSE BUTTON" ;;
        *)   symbol="mouse:${code}" ;;
      esac
      echo "${line/mouse:${code}/$symbol}"
    else
      echo "$line"
    fi
  done
}

# Fetch Hyprland keybindings
dynamic_bindings() {
  hyprctl -j binds |
    jq -r '.[] | {modmask, key, keycode, description, dispatcher, arg} | "\(.modmask),\(.key)@\(.keycode),\(.description),\(.dispatcher),\(.arg)"' |
    sed -r \
      -e 's/null//' \
      -e 's/@0//' \
      -e 's/,@/,code:/' \
      -e 's/^0,/,/' \
      -e 's/^1,/SHIFT,/' \
      -e 's/^4,/CTRL,/' \
      -e 's/^5,/SHIFT CTRL,/' \
      -e 's/^8,/ALT,/' \
      -e 's/^9,/SHIFT ALT,/' \
      -e 's/^12,/CTRL ALT,/' \
      -e 's/^13,/SHIFT CTRL ALT,/' \
      -e 's/^64,/SUPER,/' \
      -e 's/^65,/SUPER SHIFT,/' \
      -e 's/^68,/SUPER CTRL,/' \
      -e 's/^69,/SUPER SHIFT CTRL,/' \
      -e 's/^72,/SUPER ALT,/' \
      -e 's/^73,/SUPER SHIFT ALT,/' \
      -e 's/^76,/SUPER CTRL ALT,/' \
      -e 's/^77,/SUPER SHIFT CTRL ALT,/'
}

# Bash/Terminal keybindings in the same CSV format
bash_bindings() {
  cat <<'EOF'
,━━━━━━━━ BASH / TERMINAL ━━━━━━━━,,
CTRL,T,Fuzzy file search (fzf),,
CTRL,R,Fuzzy command history (fzf),,
ALT,C,Fuzzy directory navigation (fzf),,
,**<TAB>,Fuzzy path completion (fzf),,
CTRL,A,Jump to beginning of line,,
CTRL,E,Jump to end of line,,
CTRL,U,Clear line before cursor,,
CTRL,K,Clear line after cursor,,
CTRL,W,Delete word before cursor,,
CTRL,L,Clear screen,,
CTRL,C,Cancel current command,,
CTRL,D,Exit shell / EOF,,
CTRL,Z,Suspend current process,,
ALT,B,Move backward one word,,
ALT,F,Move forward one word,,
ALT,D,Delete word after cursor,,
ALT,Backspace,Delete word before cursor,,
CTRL,P / ↑,Previous command in history,,
CTRL,N / ↓,Next command in history,,
EOF
}

# Parse and format keybindings
parse_bindings() {
  awk -F, '
{
    # Combine the modifier and key (first two fields)
    key_combo = $1 " + " $2;

    # Clean up: strip leading "+" if present, trim spaces
    gsub(/^[ \t]*\+?[ \t]*/, "", key_combo);
    gsub(/[ \t]+$/, "", key_combo);

    # Use description, if set
    action = $3;

    if (action == "") {
        # Reconstruct the command from the remaining fields
        for (i = 4; i <= NF; i++) {
            action = action $i (i < NF ? "," : "");
        }

        # Clean up trailing commas, remove leading "exec, ", and trim
        sub(/,$/, "", action);
        gsub(/(^|,)[[:space:]]*exec[[:space:]]*,?/, "", action);
        gsub(/^[ \t]+|[ \t]+$/, "", action);
        gsub(/[ \t]+/, " ", key_combo);  # Collapse multiple spaces to one

        # Escape XML entities
        gsub(/&/, "\\&amp;", action);
        gsub(/</, "\\&lt;", action);
        gsub(/>/, "\\&gt;", action);
        gsub(/"/, "\\&quot;", action);
        gsub(/'"'"'/, "\\&apos;", action);
    }

    if (action != "") {
        printf "%-35s → %s\n", key_combo, action;
    }
}'
}

monitor_height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
menu_height=$((monitor_height * 50 / 100))

build_keymap_cache

{
  dynamic_bindings
  bash_bindings
} |
  sort -u |
  parse_keycodes |
  parse_bindings |
  walker --dmenu -p 'Keybindings Reference' --width 900 --height "$menu_height"
