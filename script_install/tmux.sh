#!/bin/bash

#tmux install
sudo pacman -S tmux

#tmp plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

mkdir -p ~/.config/tmux/plugins/catppuccin
mkdir -p ~/.config/tmux/plugins/tmux-plugins/tmux-cpu

# check version on:
# https://github.com/catppuccin/tmux
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

git clone https://github.com/tmux-plugins/tmux-cpu ~/.config/tmux/plugins/tmux-plugins/tmux-cpu/

