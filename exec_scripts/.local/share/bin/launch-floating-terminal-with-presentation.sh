#!/bin/bash

cmd="$*"
exec setsid uwsm-app -- xdg-terminal-exec --app-id=org.albibenni.terminal --title=Albibenni -e bash -c "show-logo.sh; $cmd; show-done.sh"
