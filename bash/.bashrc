# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

#NOTE: Enable bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# if [ -f ~/.local/share/omarchy/default/bash/rc ]; then
#   source ~/.local/share/omarchy/default/bash/rc
# fi

# NOTE: SHELL
if [ -f ~/.config/bash/shell.sh ]; then
    source ~/.config/bash/shell.sh
fi

# NOTE: alias
if [ -f ~/.config/bash/bash_alias.sh ]; then
    source ~/.config/bash/bash_alias.sh
fi
# NOTE: init
if [ -f ~/.config/bash/bash_init.sh ]; then
    source ~/.config/bash/bash_init.sh
fi

# NOTE: source scripts
PERSONAL=$XDG_CONFIG_HOME/personal
# scripts functions auto sourced
for i in $(find -L $PERSONAL -type f); do
    source $i
done

# NOTE: ENVS
if [ -f ~/.config/bash/bash_envs.sh ]; then
    source ~/.config/bash/bash_envs.sh
fi

# NOTE: bind from set
[[ $- == *i* ]] && bind -f ~/.config/bash/inputrc

# NOTE: BINDS
# Ctrl+s to reload bashrc
if [ -f ~/.config/bash/bash_bind.sh ]; then
    source ~/.config/bash/bash_bind.sh
fi

# Source bash profile (needs Omarchy functions like addToPathFront)
# if [ -f ~/.bash_profile ]; then
#   source ~/.bash_profile
# fi

# Ctrl+T - Fuzzy file search
# - Type to search files in current directory and subdirectories
# - Navigate with arrow keys, select with Enter
# - Multi-select with Tab
#
# Ctrl+R - Fuzzy command history search
# - Search through your bash history interactively
# - Much better than the default reverse search
#
# Alt+C - Fuzzy directory navigation
# - Search and cd into directories
#
# **<Tab> - Fuzzy completion (trigger completion)
# - Works for paths, commands, etc.
# - Example: vim **<Tab> will open fzf to select a file
# - Example: cd **<Tab> will fuzzy search directories
# - Example: kill -9 **<Tab> will search processes

#NOTE: Enable fzf key bindings and fuzzy completion
if [ -f /usr/share/fzf/completion.bash ]; then
    source /usr/share/fzf/completion.bash
fi
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
fi

# Load kubectl completion for bash (only if kubectl is installed)
if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

echo "Hello $USER"
fastfetch

# Disable terminal flow control (Ctrl+s/Ctrl+q) so we can use Ctrl+s
stty -ixon
