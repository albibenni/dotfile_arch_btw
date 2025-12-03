#NOTE: view
alias ls='ls --color=auto'
alias grep='grep --color=auto'

#NOTE: codes
alias vim=nvim
alias pn=pnpm
alias python=python3

#NOTE: move
alias cdd="cd ~/dotfiles/"
alias storage="cd $STORAGE" #lsblk
alias vid="nvim ~/dotfiles/"
alias vimvim="nvim ~/dotfiles/nvim/.config/nvim/"
alias vimux="nvim ~/dotfiles/tmux/.config/tmux/tmux.conf"

#NOTE: git alias
alias ga="git add -A"
alias gc="git commit"
alias gp="git push"
alias glool="git --no-pager log --oneline --decorate --graph"
alias gloo="git --no-pager log -n 30 --oneline --decorate --graph"
alias gst="git status -b"
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias gdup="git diff @{upstream}"

#NOTE: hyprland
alias wayrs="pkill waybar && sleep 1 && waybar &"

#NOTE: kubectl
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgpw="kubectl get pods -o wide"

# NOTE: from omarchy
#
#
# File system
if command -v eza &>/dev/null; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

if command -v zoxide &>/dev/null; then
    alias cd="zd"
    zd() {
        if [ $# -eq 0 ]; then
            builtin cd ~ && return
        elif [ -d "$1" ]; then
            builtin cd "$1"
        else
            z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
        fi
    }
fi

open() {
    xdg-open "$@" >/dev/null 2>&1 &
}

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias d='docker'
alias r='rails'
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
