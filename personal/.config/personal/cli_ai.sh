#!/usr/bin/env bash

uclaude() {
    npm install -g @anthropic-ai/claude-code
}

cclaude() {
    uclaude
    claude
}

gem() {
    gemini
}

igem() {
    npm install -g @google/gemini-cli
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

# CODEX
igpt() {
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
}

cdx() {
    if command -v codex >/dev/null 2>&1; then
        command codex "$@"
    else
        echo "Codex CLI (codex) not found. Run 'igpt' to install."
    fi
}
