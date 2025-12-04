#!/bin/bash

APP_ID="org.albibenni.$(basename $1)"
LAUNCH_COMMAND="launch-tui $@"

exec launch-or-focus.sh "$APP_ID" "$LAUNCH_COMMAND"
