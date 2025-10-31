#! /bin/bash

# Check if Notion is already installed
if [ -d "$HOME/.notion" ]; then
    echo "Notion is already installed."
    exit 0
fi


# Install Notion using the AUR package
yay -S notion-app-electron
