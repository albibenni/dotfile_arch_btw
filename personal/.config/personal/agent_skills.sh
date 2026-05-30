#!/usr/bin/env bash

# Agent Skills Management
# Standardizes skill locations for Gemini, Claude, and Omarchy
# Uses a surgical "File-Level" approach to avoid whole-folder symlinks.

setup-agent-skills() {
    local GREEN='\033[0;32m'
    local BLUE='\033[0;34m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m'

    local DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && cd ../../.. && pwd)"
    local SKILLS_SOURCE="$DOTFILES_DIR/agent/.config/agent/skills"
    
    # Standard paths to surgically populate
    local AGENT_PATHS=(
        "$HOME/.config/agent"
        "$HOME/.agents"
    )

    echo -e "${BLUE}=== Setting up Agent Skills (Surgical File-Level Symlinks) ===${NC}"

    if [[ ! -d "$SKILLS_SOURCE" ]]; then
        echo -e "  ${RED}✗${NC} Source directory not found: $SKILLS_SOURCE"
        return 1
    fi

    # 1. Prepare target directories
    for base_path in "${AGENT_PATHS[@]}"; do
        local target_skills_dir="$base_path/skills"
        
        # If the path is a symlink (link to a folder), we UNLINK it.
        # This removes the "shortcut" but does NOT touch the folder it points to.
        if [[ -L "$target_skills_dir" ]]; then
            echo -e "  ${YELLOW}→${NC} Unlinking folder symlink at $target_skills_dir"
            unlink "$target_skills_dir"
        fi
        
        # Now that the link is gone (or if it was never there), create a real directory.
        mkdir -p "$target_skills_dir"
    done

    # 2. Link individual files surgically to all paths
    while IFS= read -r -d '' source_file; do
        local rel_path="${source_file#$SKILLS_SOURCE/}"
        
        # Skip certain files that aren't part of the skill logic
        [[ "$rel_path" == ".gitignore" ]] && continue
        
        echo -e "  ${BLUE}Surgically linking: ${NC}$rel_path"

        for base_path in "${AGENT_PATHS[@]}"; do
            local target_file="$base_path/skills/$rel_path"
            local target_dir="$(dirname "$target_file")"

            mkdir -p "$target_dir"
            # Link the specific file
            if ln -nsf "$source_file" "$target_file"; then
                echo -e "    ${GREEN}✓${NC} Linked to $(basename "$base_path")"
            else
                echo -e "    ${RED}✗${NC} Failed to link to $(basename "$base_path")"
            fi
        done
    done < <(find "$SKILLS_SOURCE" -type f -not -path '*/.git*' -print0)

    echo -e "\n${GREEN}Done! Individual skill files linked surgically across all paths.${NC}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup-agent-skills "$@"
fi
