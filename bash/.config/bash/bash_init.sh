if command -v mise &>/dev/null; then
    eval "$(mise activate bash)"
fi

# Keep installed Go applications across mise Go upgrades.
export GOBIN="$HOME/.local/bin"
export PATH="$GOBIN:$PATH"

# if command -v fnm &>/dev/null; then
#     eval "$(fnm env --use-on-cd)"
# fi

if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

if command -v try &>/dev/null; then
    eval "$(SHELL=/bin/bash command try init ~/Work/tries)"
fi

if command -v fzf &>/dev/null; then
    if [[ -f /usr/share/fzf/completion.bash ]]; then
        source /usr/share/fzf/completion.bash
    fi
    if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
        source /usr/share/fzf/key-bindings.bash
    fi
fi

# CUSTOM APPS

if command -v task-planner &>/dev/null; then
    if task_planner_completion=$(task-planner completion bash); then
        eval "$task_planner_completion"
    fi
    unset task_planner_completion
fi
