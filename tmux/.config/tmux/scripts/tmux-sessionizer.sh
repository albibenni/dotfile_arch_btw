#! /usr/bin/env bash

if [[ $# -eq 1 ]]; then
    session=$1
else
    session=$(find ~/dotfile/ ~/benni-projects/ ~/work-projects/ -mindepth 0 -maxdepth 2 -type d | fzf)
fi

if [[ -z $session ]]; then
    exit 0
fi

session_name=$(basename "$session" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $session_name -c $session
    exit 0
fi

if ! tmux has-session -t=$session_name 2> /dev/null; then
    tmux new-session -ds $session_name -c $session
fi

tmux switch-client -t $session_name

# This script will find all directories in the home directory,  ~/benni-projects/ , and  ~/work-projects/  and pipe them into  fzf . When you select a directory, it will create a new tmux session with the name of the directory and switch to it.
# You can also use  fzf  to select a tmux session to switch to.
 # Path: tmux-sessionizer
