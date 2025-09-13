# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias vim=nvim

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

echo "Hello $USER"

alias cdd="cd ~/.dotfiles/"
alias pn=pnpm
alias vim=nvim
alias python=python3
alias glool="git --no-pager log --oneline --decorate --graph"
alias gloo="git --no-pager log -n 30 --oneline --decorate --graph"
alias vid="nvim ~/.dotfiles/"
alias vimvim="nvim ~/.dotfiles/nvim/.config/nvim/"
alias vish="nvim ~/.dotfiles/zsh/.zshrc"
alias vimux="nvim ~/.dotfiles/tmux/.config/tmux/tmux.conf"
alias vimaero="nvim ~/.dotfiles/aerospace/.config/aerospace/aerospace.toml"
# pomodoro timer aliases for rust_can_make_you_focus app
alias pomocode="sudo ~/.dotfiles/scripts/scripts/rust_can_make_you_focus coding"
alias pomocodeyt="sudo ~/.dotfiles/scripts/scripts/rust_can_make_you_focus coding_yt"
alias pomoall="sudo ~/.dotfiles/scripts/scripts/rust_can_make_you_focus coding"
alias pomostudy="sudo ~/.dotfiles/scripts/scripts/rust_can_make_you_focus studying"
alias pomostudyyt="sudo ~/.dotfiles/scripts/scripts/rust_can_make_you_focus studying_yt"


export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"


#ZSH_THEME=amuse
ZSH_THEME=robbyrussell

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export MANPAGER='nvim +Man!'


DISABLE_MAGIC_FUNCTIONS=true
source $ZSH/oh-my-zsh.sh
source ~/.zsh_profile

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# # pnpm
# export PNPM_HOME="/Users/benni/Library/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end
# bun completions


