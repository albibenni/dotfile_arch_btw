#!/bin/bash

refresh-config.sh swayosd/config.toml
refresh-config.sh swayosd/style.css
restart-app.sh swayosd-server
