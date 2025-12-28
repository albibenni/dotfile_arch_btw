VIM="nvim"
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/albibenni/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/albibenni/.lmstudio/bin"
# End of LM Studio CLI section

export XDG_CONFIG_HOME=$HOME/.config
export TERMINAL=ghostty
export VISUAL='nvim'
export EDITOR='nvim'
export MANPAGER='nvim +Man!'
export STORAGE="/run/media/albibenni/Benni"

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export SUDO_EDITOR="$EDITOR"

export NRDP="$HOME/work/nrdp"
export NRDP_BUILDS="$HOME/work/builds"
export CC="clang"
export CXX="clang++"
export PYTHONBREAKPOINT="pudb.set_trace"
export GOPATH=$HOME/go
export GIT_EDITOR=$VIM
export DOTFILES=$HOME/.dotfiles

## FZF customization
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
# Make Tab trigger fzf completion  needing ** prefix - tab normal completion
export FZF_COMPLETION_TRIGGER='**'

# lua5.1
export PATH=~/.local/bin/:$PATH
export PATH=$HOME/.cargo/bin:$PATH

addToPathFront $HOME/.config/tmux/scripts
addToPathFront $HOME/.config/scripts
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.local/share/bin

# addToPathFront $HOME/go/bin

# NOTE: from omarchy
# Editor used by CLI
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# Screenshot and screenrecord directories
export OMARCHY_SCREENSHOT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
export OMARCHY_SCREENRECORD_DIR="${XDG_VIDEOS_DIR:-$HOME/Videos}"
