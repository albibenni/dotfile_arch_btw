#!/usr/bin/env bash
# cht.sh - cheat.sh client

# usage: cht.sh <language> <query>
languages=$(echo "golang c cpp docker javascript typescript python ruby rust swift php perl lua haskell bash" | tr " " "\n")
core_utils=$(echo "git curl find xargs sed awk" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "my query: " query

if echo "$languages" | grep -qs "$selected"; then
    tmux split-window -h bash -c "curl -s cht.sh/$selected/$(echo $query | tr " " "+") | less"
else
    tmux split-window -h bash -c "curl -s cht.sh/$selected~$query | less"
fi
