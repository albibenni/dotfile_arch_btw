#!/usr/bin/env zsh

# vless: View piped input in read-only Neovim with man page formatting.
# Usage: command | vless or command 2>&1 | vless
vless() {
  if [ -p /dev/stdin ]; then
    # There's a pipe, buffer the input
    local tmp=$(mktemp)
    cat > "$tmp"
    if [ -s "$tmp" ]; then
      # File has content
      nvim -R -c 'set ft=man' "$tmp"
      rm "$tmp"
    else
      # Pipe is empty
      rm "$tmp"
      printf "\033[1;31m╔══════════════════════════════════════════════════════════════╗\033[0m\n" >&2
      printf "\033[1;31m║\033[0m \033[1;33m%-60s\033[0m \033[1;31m║\033[0m\n" "⚠ ERROR - vless" >&2
      printf "\033[1;31m╠══════════════════════════════════════════════════════════════╣\033[0m\n" >&2
      printf "\033[1;31m║\033[0m %-60s \033[1;31m║\033[0m\n" "No data in pipe. Did you mean to use '2>&1'?" >&2
      printf "\033[1;31m╠══════════════════════════════════════════════════════════════╣\033[0m\n" >&2
      printf "\033[1;31m║\033[0m \033[1;36m%-60s\033[0m \033[1;31m║\033[0m\n" "Usage:" >&2
      printf "\033[1;31m║\033[0m   \033[1;32m%-58s\033[0m \033[1;31m║\033[0m\n" "command 2>&1 | vless  (for stderr output)" >&2
      printf "\033[1;31m║\033[0m   \033[1;32m%-58s\033[0m \033[1;31m║\033[0m\n" "command | vless       (for stdout output)" >&2
      printf "\033[1;31m╚══════════════════════════════════════════════════════════════╝\033[0m\n" >&2
      return 1
    fi
  else
    echo "\033[1;33m⚠ Usage:\033[0m command | vless" >&2
    return 1
  fi
}
