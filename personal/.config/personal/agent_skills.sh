#!/usr/bin/env bash

# Agent Skills Management
# Standardizes skill locations for Gemini, Claude, and Omarchy

setup-agent-skills() {
    local GREEN='\033[0;32m'
    local BLUE='\033[0;34m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m'

    local DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && cd ../../.. && pwd)"
    local SKILLS_SOURCE="$DOTFILES_DIR/agent/.config/agent/skills"
    local SKILLS_TARGET="$HOME/.config/agent/skills"

    echo -e "${BLUE}=== Setting up Agent Skills Standard ===${NC}"

    # 1. Ensure the standard directory exists
    # We want it to be a real directory so we can "hybrid" link into it
    if [[ ! -d "$SKILLS_TARGET" ]]; then
        mkdir -p "$SKILLS_TARGET"
        echo -e "  ${GREEN}✓${NC} Created standard directory: $SKILLS_TARGET"
    else
        echo -e "  ${GREEN}✓${NC} Standard directory already exists: $SKILLS_TARGET"
    fi

    # 2. Link individual skills from dotfiles (Hybrid approach)
    if [[ -d "$SKILLS_SOURCE" ]]; then
        for skill in "$SKILLS_SOURCE"/*; do
            # Handle both directories and potential files (like SKILL.md if placed there)
            [[ ! -e "$skill" ]] && continue
            local skill_name=$(basename "$skill")
            
            # Skip hidden files
            [[ "$skill_name" == .* ]] && continue

            if ln -nsf "$skill" "$SKILLS_TARGET/$skill_name"; then
                echo -e "  ${GREEN}✓${NC} Linked skill: $skill_name"
            else
                echo -e "  ${RED}✗${NC} Failed to link skill: $skill_name"
            fi
        done
    else
        echo -e "  ${YELLOW}⚠${NC} Skills source not found in dotfiles: $SKILLS_SOURCE"
    fi

    # 3. Create cross-agent symlinks for current compatibility
    local AGENT_PATHS=(
        "$HOME/.gemini"
        "$HOME/.claude"
        "$HOME/.agents"
    )

    for path in "${AGENT_PATHS[@]}"; do
        mkdir -p "$path"
        if ln -nsf "$SKILLS_TARGET" "$path/skills"; then
            echo -e "  ${GREEN}✓${NC} Linked $path/skills -> $SKILLS_TARGET"
        else
            echo -e "  ${RED}✗${NC} Failed to link $path/skills"
        fi
    done

    echo -e "\n${GREEN}Done! All agents now use the unified skill directory.${NC}"
}

# If script is being executed directly (not sourced), run the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup-agent-skills "$@"
fi
