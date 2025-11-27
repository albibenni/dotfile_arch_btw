# If not running interactively, don't do anything (leave this at the top of this file)

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# if [ -f ~/.local/share/omarchy/default/bash/rc ]; then
#   source ~/.local/share/omarchy/default/bash/rc
# fi

# NOTE: SHELL
if [ -f ~/.config/bash/.shell ]; then
    source ~/.config/bash/.shell
fi

# NOTE: alias
if [ -f ~/.config/bash/.bash_alias ]; then
    source ~/.config/bash/.bash_alias
fi
# NOTE: init
if [ -f ~/.config/bash/.bash_init ]; then
    source ~/.config/bash/.bash_init
fi

# NOTE: source scripts
PERSONAL=$XDG_CONFIG_HOME/personal
# scripts functions auto sourced
for i in $(find -L $PERSONAL -type f); do
    source $i
done

# NOTE: ENVS
if [ -f ~/.config/bash/.bash_envs ]; then
    source ~/.config/bash/.bash_envs
fi

# NOTE: bind from set
[[ $- != *i* ]] && bind -f ~/.config/bash/.inputrc

# NOTE: BINDS
# Ctrl+s to reload bashrc
if [ -f ~/.config/bash/.bash_bind ]; then
    source ~/.config/bash/.bash_bind
fi




# Source bash profile (needs Omarchy functions like addToPathFront)
# if [ -f ~/.bash_profile ]; then
#   source ~/.bash_profile
# fi

# Load kubectl completion for bash (only if kubectl is installed)
if command -v kubectl &> /dev/null; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

echo "Hello $USER"


# Disable terminal flow control (Ctrl+s/Ctrl+q) so we can use Ctrl+s
stty -ixon

