#!/bin/bash

exec setsid uwsm-app -- xdg-terminal-exec --app-id=org.albibenni.$(basename $1) -e "$1" "${@:2}"
