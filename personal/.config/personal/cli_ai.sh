#!/usr/bin/env bash

uclaude() {
    sudo npm install -g @anthropic-ai/claude-code
}

cclaude() {
    uclaude
    claude
}

gem() {
    gemini
}

# Antigravity CLI (Successor to Gemini CLI)
agy() {
    if command -v agy >/dev/null 2>&1; then
        command agy "$@"
    else
        echo "Antigravity CLI (agy) not found. Run 'install-agy' to install."
    fi
}

install-agy() {
    curl -fsSL https://antigravity.google/cli/install.sh | bash
}
