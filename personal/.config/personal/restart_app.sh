#!/bin/bash

restartApp(){
    pkill -x $1
    setsid uwsm-app -- $1 >/dev/null 2>&1 &
}

restart-waybar(){
    restartApp waybar
}

restart-mako(){
    makoctl reload
}

restart-swayosd(){
    restartApp swayosd-server
}

restart-wifi(){
    echo -e "Unblocking wifi...\n"
    rfkill unblock wifi
    rfkill list wifi
}

restart-pipewire(){
    echo -e "Restarting pipewire audio service...\n"
    systemctl --user restart pipewire.service
}

restart-fcitx5(){
    restartApp fcitx5
}

restart-walker(){
    pkill elephant
    pkill walker

    # Detect if we're running as root (from pacman hook)
    if [[ $EUID -eq 0 ]]; then
      # Get the owner of this script to determine which user to run as
      SCRIPT_OWNER=$(stat -c '%U' "$0")
      USER_UID=$(id -u "$SCRIPT_OWNER")

      # Restart services as the script owner
      systemd-run --uid="$SCRIPT_OWNER" --setenv=XDG_RUNTIME_DIR="/run/user/$USER_UID" \
        bash -c "
          systemctl --user restart elephant.service
          setsid walker --gapplication-service &
        "
    else
      elephant service enable 2>/dev/null
      systemctl --user restart elephant.service
      setsid walker --gapplication-service &
    fi
}
