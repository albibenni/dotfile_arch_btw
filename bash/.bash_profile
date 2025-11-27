# Load ble.sh early (will be attached at the end of .bashrc)
# Only load if not already loaded (prevents issues when re-sourcing)
if [[ ! ${BLE_VERSION-} ]] && [ -f ~/.local/share/blesh/ble.sh ]; then
  source ~/.local/share/blesh/ble.sh --noattach
  ble-color-setface auto_complete fg=238,underline    # Set autocomplete color to greyed out and underlined until activated
  ble-face -s syntax_error fg=242                     # Set error or backspace to greyed out
  bleopt complete_ambiguous=                          # Disable ambigous completion from generating
fi

export XDG_CONFIG_HOME=$HOME/.config
export TERMINAL=ghostty
export VISUAL='nvim'
export EDITOR='nvim'
export MANPAGER='nvim +Man!'

export STORAGE="/run/media/albibenni/Benni"
VIM="nvim"

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export SUDO_EDITOR="$EDITOR"

PERSONAL=$XDG_CONFIG_HOME/personal

for i in $(find -L $PERSONAL -type f); do
    source $i
done

export NRDP="$HOME/work/nrdp"
export NRDP_BUILDS="$HOME/work/builds"
export CC="clang"
export CXX="clang++"
export PYTHONBREAKPOINT="pudb.set_trace"
export GOPATH=$HOME/go
export GIT_EDITOR=$VIM
export N_PREFIX="$HOME/.local/n"

# lua5.1
export PATH=~/.local/bin/:$PATH
export PATH=$HOME/.cargo/bin:$PATH

export DOTFILES=$HOME/.dotfiles

export PATH="$N_PREFIX/bin:$PATH"

addToPathFront $HOME/.config/tmux/scripts
addToPathFront $HOME/.config/scripts
addToPathFront $HOME/.local/bin
# addToPathFront $HOME/go/bin

# Bash keybindings (equivalent to zsh bindkey)
# Ctrl+f to run tmux-sessionizer
bind -x '"\C-f":"tmux-sessionizer.sh"'

