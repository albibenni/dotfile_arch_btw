#!/bin/bash

# Install node via fnm
sudo pacman -S go rustup lua51 jdk-openjdk maven gradle kafka

yay -S bun

rustup default stable
