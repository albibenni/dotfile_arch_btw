#!/bin/bash

# Ensure walker is set to autostart
mkdir -p ~/.config/autostart/
cp $OMARCHY_PATH/autostart/walker.desktop ~/.config/autostart/

refresh-config.sh walker/config.toml
refresh-config.sh elephant/calc.toml
refresh-config.sh elephant/desktopapplications.toml
restart-walker.sh
