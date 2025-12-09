#!/bin/bash

if (($# == 0)); then
  echo "Usage: launch-or-focus-webapp [window-pattern] [url-and-flags...]"
  exit 1
fi

WINDOW_PATTERN="$1"
shift
LAUNCH_COMMAND="/home/albibenni/.local/share/bin/launch-webapp.sh $@"

exec launch-or-focus.sh "$WINDOW_PATTERN" "$LAUNCH_COMMAND"
