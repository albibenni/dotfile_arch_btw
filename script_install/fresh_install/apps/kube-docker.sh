#! /bin/bash

sudo pacman -Syy
yay -S --needed rancher-desktop

sudo pacman -S --needed helm k9s
