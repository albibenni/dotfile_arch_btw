# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias vim=nvim

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

echo "Hello $USER"

alias cdd="cd ~/dotfiles/"
alias storage="cd $storage" #lsblk
alias pn=pnpm
alias vim=nvim
alias python=python3
alias glool="git --no-pager log --oneline --decorate --graph"
alias gloo="git --no-pager log -n 30 --oneline --decorate --graph"
alias gst="git status -b --color=always"
alias vid="nvim ~/dotfiles/"
alias vimvim="nvim ~/dotfiles/nvim/.config/nvim/"
alias vish="nvim ~/dotfiles/zsh/.zshrc"
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

# # Enable zsh completion system (if not already enabled)
autoload -Uz compinit
compinit

 # Load kubectl completion for zsh (only if kubectl is installed)
if command -v kubectl &> /dev/null; then
  source <(kubectl completion zsh)
  # Note: 'complete' is bash-specific, using zsh style completion instead
  compdef k=kubectl
fi


ZSH_THEME=amuse
#ZSH_THEME=robbyrussell


plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

DISABLE_MAGIC_FUNCTIONS=true
# Set ZSH variable to oh-my-zsh installation path
export ZSH="$HOME/.oh-my-zsh"
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source $ZSH/oh-my-zsh.sh
fi

if [ -f ~/.zsh_profile ]; then
  source ~/.zsh_profile
fi



### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/albibenni/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/albibenni/.lmstudio/bin"
# End of LM Studio CLI section

