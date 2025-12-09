#!/bin/bash

# Exit early if we don't have the tte show
if ! command -v tte &>/dev/null; then
  exit 1
fi

# Create screensaver directory and text file if they don't exist
screensaver_dir="$HOME/.local/share/screensaver"
screensaver_file="$screensaver_dir/text.txt"

if [[ ! -d "$screensaver_dir" ]]; then
  mkdir -p "$screensaver_dir"
fi

if [[ ! -f "$screensaver_file" ]]; then
  echo "SCREENSAVER ACTIVE" > "$screensaver_file"
fi

# Exit early if screensave is already running
pgrep -f org.albibenni.screensaver && exit 0

# Allow screensaver to be turned off but also force started
if [[ -f ~/.local/state/benni/toggles/screensaver-off ]] && [[ $1 != "force" ]]; then
  exit 1
fi

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')
terminal=$(xdg-terminal-exec --print-id)

for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
  hyprctl dispatch focusmonitor $m

  case $terminal in
  *Alacritty*)
    hyprctl dispatch exec -- \
      alacritty --class=org.albibenni.screensaver \
      --config-file ~/.config/alacritty/screensaver.toml \
      -e tte --input-file ~/.local/share/screensaver/text.txt slide
    ;;
  *ghostty*)
    hyprctl dispatch exec -- \
      ghostty --class=org.albibenni.screensaver \
      --font-size=18 \
      -e tte --input-file ~/.local/share/screensaver/text.txt slide
    ;;
  *kitty*)
    hyprctl dispatch exec -- \
      kitty --class=org.albibenni.screensaver \
      --override font_size=18 \
      --override window_padding_width=0 \
      -e tte --input-file ~/.local/share/screensaver/text.txt slide
    ;;
  *)
    notify-send "✋  Screensaver only runs in Alacritty, Ghostty, or Kitty"
    ;;
  esac
done

hyprctl dispatch focusmonitor $focused
