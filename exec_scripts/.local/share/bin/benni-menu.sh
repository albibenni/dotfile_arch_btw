#!/bin/bash

# Set to true when going directly to a submenu, so we can exit directly
BACK_TO_EXIT=false

back_to() {
    local parent_menu="$1"

    if [[ "$BACK_TO_EXIT" == "true" ]]; then
        exit 0
    elif [[ -n "$parent_menu" ]]; then
        "$parent_menu"
    else
        show_main_menu
    fi
}

menu() {
    local prompt="$1"
    local options="$2"
    local extra="$3"
    local preselect="$4"

    read -r -a args <<<"$extra"

    if [[ -n "$preselect" ]]; then
        local index
        index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
        if [[ -n "$index" ]]; then
            args+=("-c" "$index")
        fi
    fi

    echo -e "$options" | launch-walker.sh --dmenu --width 295 --minheight 1 --maxheight 630 -p "$prompt…" "${args[@]}" 2>/dev/null
}

terminal() {
    xdg-terminal-exec --app-id=org.albibenni.terminal "$@"
}

present_terminal() {
    launch-floating-terminal-with-presentation.sh $1
}

install() {
    present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm $2"
}

install_and_launch() {
    present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm $2 && setsid gtk-launch $3"
}

install_font() {
    present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm --needed $2 && sleep 2 && font-set.sh '$3'"
}

aur_install() {
    present_terminal "echo 'Installing $1 from AUR...'; yay -S --noconfirm $2"
}

aur_install_and_launch() {
    present_terminal "echo 'Installing $1 from AUR...'; yay -S --noconfirm $2 && setsid gtk-launch $3"
}

show_learn_menu() {
    case $(menu "Learn" "  Keybindings\n  Hyprland\n󰣇  Arch\n󱆃  Bash") in
    *Keybindings*) menu-keybindings.sh ;;
    *Hyprland*) launch-webapp.sh "https://wiki.hypr.land/" ;;
    *Arch*) launch-webapp.sh "https://wiki.archlinux.org/title/Main_page" ;;
    *Bash*) launch-webapp.sh "https://devhints.io/bash" ;;
    *) show_main_menu ;;
    esac
}

show_trigger_menu() {
    case $(menu "Trigger" "  Capture\n  Share\n󰔎  Toggle") in
    *Capture*) show_capture_menu ;;
    *Share*) show_share_menu ;;
    *Toggle*) show_toggle_menu ;;
    *) show_main_menu ;;
    esac
}

show_capture_menu() {
    case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰃉  Color") in
    *Screenshot*) show_screenshot_menu ;;
    *Screenrecord*) show_screenrecord_menu ;;
    *Color*) pkill hyprpicker || hyprpicker -a ;;
    *) show_trigger_menu ;;
    esac
}

show_screenshot_menu() {
    case $(menu "Screenshot" "  Snap with Editing\n  Straight to Clipboard") in
    *Editing*) cmd-screenshot.sh smart ;;
    *Clipboard*) cmd-screenshot.sh smart clipboard ;;
    *) show_capture_menu ;;
    esac
}

show_screenrecord_menu() {
    cmd-screenrecord.sh --stop-recording && exit 0

    case $(menu "Screenrecord" "  With desktop audio\n  With desktop + microphone audio\n  With desktop + microphone audio + webcam") in
    *"With desktop audio") cmd-screenrecord.sh --with-desktop-audio ;;
    *"With desktop + microphone audio") cmd-screenrecord.sh --with-desktop-audio --with-microphone-audio ;;
    *"With desktop + microphone audio + webcam") cmd-screenrecord.sh --with-desktop-audio --with-microphone-audio --with-webcam ;;
    *) back_to show_capture_menu ;;
    esac
}

show_share_menu() {
    case $(menu "Share" "  Clipboard\n  File \n  Folder") in
    *Clipboard*) cmd-share.sh clipboard ;;
    *File*) terminal bash -c "omarchy-cmd-share file" ;;
    *Folder*) terminal bash -c "omarchy-cmd-share folder" ;;
    *) back_to show_trigger_menu ;;
    esac
}

show_toggle_menu() {
    case $(menu "Toggle" "󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰍜  Top Bar") in
    *Screensaver*) toggle-screensaver.sh ;;
    *Nightlight*) toggle-nightlight.sh ;;
    *Idle*) toggle-idle.sh ;;
    *Bar*) toggle-waybar.sh ;;
    *) show_trigger_menu ;;
    esac
}

show_style_menu() {
    case $(menu "Style" "󰸌  Theme\n  Font\n  Background\n  Screensaver\n  Install") in
    *Theme*) show_theme_menu ;;
    *Font*) show_font_menu ;;
    *Background*) theme-next.sh next-bg ;;
    *Screensaver*) open_in_editor ~/.local/share/bin/launch-screensaver.sh ;;
    *Install*) show_install_style_menu ;;
    *) show_main_menu ;;
    esac
}

show_theme_menu() {
    launch-walker -m menus:bennithemes --width 800 --minheight 400
}

show_font_menu() {
    theme=$(menu "Font" "$(font-list.sh)" "--width 350" "$(font-current.sh)")
    if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
        back_to show_style_menu
    else
        font-set.sh "$theme"
    fi
}

show_setup_menu() {
    local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n󰍹  Monitors"
    [ -f ~/.config/hypr/bindings.conf ] && options="$options\n  Keybindings"
    [ -f ~/.config/hypr/input.conf ] && options="$options\n  Input"
    options="$options\n  Defaults\n󰱔  DNS\n  Security\n  Config"

    case $(menu "Setup" "$options") in
    *Audio*) launch-or-focus-tui.sh wiremix ;;
    *Wifi*) launch-wifi.sh ;;
    *Bluetooth*) launch-bluetooth.sh ;;
    *Power*) show_setup_power_menu ;;
    *DNS*) present_terminal change-dns.sh ;;
    *Security*) show_setup_security_menu ;;
    *Config*) show_setup_config_menu ;;
    *) show_main_menu ;;
    esac
}

show_setup_power_menu() {
    profile=$(menu "Power Profile" "$(powerprofile-list.sh)" "" "$(powerprofilesctl get)")

    if [[ "$profile" == "CNCLD" || -z "$profile" ]]; then
        back_to show_setup_menu
    else
        powerprofilesctl set "$profile"
    fi
}

show_setup_security_menu() {
    case $(menu "Setup" "󰈷  Fingerprint") in
    *Fingerprint*) present_terminal setup-fingerprint.sh ;;
    *) show_setup_menu ;;
    esac
}

show_install_style_menu() {
    case $(menu "Install" "󰸌  Theme\n  Background\n  Font") in
    *Theme*) present_terminal theme-install.sh ;;
    *Background*) nautilus ~/.config/current-theme/backgrounds ;;
    *Font*) show_install_font_menu ;;
    *) show_install_menu ;;
    esac
}

show_install_font_menu() {
    case $(menu "Install" "  Meslo LG Mono\n  Fira Code\n  Victor Code\n  Bistream Vera Mono" "--width 350") in
    *Meslo*) install_font "Meslo LG Mono" "ttf-meslo-nerd" "MesloLGL Nerd Font" ;;
    *Fira*) install_font "Fira Code" "ttf-firacode-nerd" "FiraCode Nerd Font" ;;
    *Victor*) install_font "Victor Code" "ttf-victor-mono-nerd" "VictorMono Nerd Font" ;;
    *Bistream*) install_font "Bistream Vera Code" "ttf-bitstream-vera-mono-nerd" "BitstromWera Nerd Font" ;;
    *) show_install_style_menu ;;
    esac
}

#TODO:
show_update_menu() {
    case $(menu "Update" " Omarchy\n󰸌  Extra Themes\n  Process\n󰇅  Hardware\n  Firmware\n  Password\n  Timezone\n  Time") in
    *Omarchy*) present_terminal omarchy-update ;;
    *Themes*) present_terminal theme-update.sh ;;
    *Process*) show_update_process_menu ;;
    *Hardware*) show_update_hardware_menu ;;
    *Firmware*) present_terminal omarchy-update-firmware ;;
    *Timezone*) present_terminal tz-select.sh ;;
    *Time*) present_terminal update-time.sh ;;
    *Password*) show_update_password_menu ;;
    *) show_main_menu ;;
    esac
}

show_update_process_menu() {
    case $(menu "Restart" "  Hypridle\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
    *Hypridle*) restart-hypridle.sh ;;
    *Hyprsunset*) restart-hyprsunset.sh ;;
    *Swayosd*) restart-swayosd.sh ;;
    *Walker*) restart-walker.sh ;;
    *Waybar*) restart-waybar.sh ;;
    *) show_update_menu ;;
    esac
}

show_update_hardware_menu() {
    case $(menu "Restart" "  Audio\n󱚾  Wi-Fi\n󰂯  Bluetooth") in
    *Audio*) present_terminal restart-pipewire.sh ;;
    *Wi-Fi*) present_terminal restart-wifi.sh ;;
    *Bluetooth*) present_terminal restart-bluetooth.sh ;;
    *) show_update_menu ;;
    esac
}

show_update_password_menu() {
    case $(menu "Update Password" "  Drive Encryption\n  User") in
    *Drive*) present_terminal drive-set-password.sh ;;
    *User*) present_terminal passwd ;;
    *) show_update_menu ;;
    esac
}

show_system_menu() {
    case $(menu "System" "  Lock\n󱄄  Screensaver\n󰤄  Suspend\n󰜉  Restart\n󰐥  Shutdown") in
    *Lock*) lock-screen.sh ;;
    *Screensaver*) launch-screensaver.sh force ;;
    *Suspend*) systemctl suspend ;;
    *Restart*) cmd-reboot.sh ;;
    *Shutdown*) cmd-shutdown.sh ;;
    *) back_to show_main_menu ;;
    esac
}

show_main_menu() {
    go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Share\n  Style\n  Setup\n  Update\n  About\n  System")"
}

go_to_menu() {
    case "${1,,}" in
    *apps*) walker -p "Launch…" ;;
    *learn*) show_learn_menu ;;
    *trigger*) show_trigger_menu ;;
    *share*) show_share_menu ;;
    *style*) show_style_menu ;;
    *theme*) show_theme_menu ;;
    *font*) show_font_menu ;;
    *screenshot*) show_screenshot_menu ;;
    *screenrecord*) show_screenrecord_menu ;;
    *setup*) show_setup_menu ;;
    *power*) show_setup_power_menu ;;
    *update*) show_update_menu ;;
    *about*) launch-about.sh ;;
    *system*) show_system_menu ;;
    esac
}

if [[ -n "$1" ]]; then
    BACK_TO_EXIT=true
    go_to_menu "$1"
else
    show_main_menu
fi
