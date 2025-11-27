# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
if [ -f ~/.local/share/omarchy/default/bash/rc ]; then
  source ~/.local/share/omarchy/default/bash/rc
fi

# Source bash profile (needs Omarchy functions like addToPathFront)
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias vim=nvim

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

echo "Hello $USER"

alias cdd="cd ~/dotfiles/"
alias storage="cd $STORAGE" #lsblk
alias pn=pnpm
alias vim=nvim
alias python=python3
alias glool="git --no-pager log --oneline --decorate --graph"
alias gloo="git --no-pager log -n 30 --oneline --decorate --graph"
alias gst="git status -b --color=always"
alias vid="nvim ~/dotfiles/"
alias vimvim="nvim ~/dotfiles/nvim/.config/nvim/"
alias vish="nvim ~/dotfiles/bash/.bashrc"
alias vimux="nvim ~/dotfiles/tmux/.config/tmux/tmux.conf"
alias vimaero="nvim ~/dotfiles/aerospace/.config/aerospace/aerospace.toml"
# pomodoro timer aliases for rust_can_make_you_focus app
alias pomocode="sudo ~/dotfiles/scripts/scripts/rust_can_make_you_focus coding"
alias pomocodeyt="sudo ~/dotfiles/scripts/scripts/rust_can_make_you_focus coding_yt"
alias pomoall="sudo ~/dotfiles/scripts/scripts/rust_can_make_you_focus coding"
alias pomostudy="sudo ~/dotfiles/scripts/scripts/rust_can_make_you_focus studying"
alias pomostudyyt="sudo ~/dotfiles/scripts/scripts/rust_can_make_you_focus studying_yt"

# hyprland
alias wayrs="pkill waybar && sleep 1 && waybar &"

# kubectl
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgpw="kubectl get pods -o wide"

# Load kubectl completion for bash (only if kubectl is installed)
if command -v kubectl &> /dev/null; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
fi

# Disable terminal flow control (Ctrl+s/Ctrl+q) so we can use Ctrl+s
stty -ixon

# Reload function that handles ble.sh properly
_reload_bashrc() {
  if [[ ${BLE_VERSION-} ]]; then
    # If ble.sh is active, reload it properly
    ble-detach
    source ~/.bashrc
  else
    # No ble.sh, just reload normally
    source ~/.bashrc
  fi
}

# Ctrl+s to reload bashrc
bind -x '"\C-s":"_reload_bashrc"'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/albibenni/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/albibenni/.lmstudio/bin"
# End of LM Studio CLI section

# Attach ble.sh if it was loaded with --noattach
[[ ${BLE_VERSION-} ]] && ble-attach
