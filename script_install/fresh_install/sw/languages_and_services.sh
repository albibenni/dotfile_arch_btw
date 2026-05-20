#!/bin/bash

# Install node via fnm
sudo pacman -S --needed go rustup lua51 jdk-openjdk maven gradle kafka

yay -S --needed bun

rustup default stable
