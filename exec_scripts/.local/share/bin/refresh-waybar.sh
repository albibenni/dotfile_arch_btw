#!/bin/bash

refresh-config.sh waybar/config.jsonc
refresh-config.sh waybar/style.css
restart-waybar.sh
