#!/usr/bin/env bash

# Function to restore dotfiles symlinks using stow
# Source this file and call: restore-dotfiles-symlinks
restore-symlinks() {
    # Colors for output
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m' # No Color

    # Get the dotfiles directory
    local script_path="${BASH_SOURCE[0]}"
    local DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "$script_path")")" && cd ../../.. && pwd)"
    local TARGET_DIR="$HOME"

    echo -e "${BLUE}=== Dotfiles Symlink Restoration Tool ===${NC}\n"
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo "Target directory: $TARGET_DIR"
    echo ""

    # Special packages to always stow (non-.config packages)
    local SPECIAL_PACKAGES=(
        "xcompose"
        "git-config"
        "ssh"
        "bash"
    )

    # Directories to skip
    # add .config folder to not fully stow
    local SKIP_DIRS=(
        ".git"
        "script_install"
        "themes"
        "obsidian"
        "elephant"
        "battery"
        "systemd"
        "user"
        "menu"
    )

    # WARNING: add the file to SKIP_DIRS too
    # Packages where individual files in .config/package/ should be symlinked
    # instead of the entire .config/package directory
    local FILE_LEVEL_PACKAGES=(
        "obsidian"
        "elephant"
        "battery"
        "systemd"
        "user"
        "menu"
    )

    # Find all packages
    local all_packages=()
    local conflicts=()

    echo -e "${BLUE}Scanning for stow packages...${NC}"
    echo ""

    # Scan for all package directories
    for dir in "$DOTFILES_DIR"/*/; do
        local package=$(basename "$dir")

        # Skip special directories
        local skip=false
        for skip_dir in "${SKIP_DIRS[@]}"; do
            if [[ "$package" == "$skip_dir" ]]; then
                skip=true
                break
            fi
        done
        [[ "$skip" == true ]] && continue

        all_packages+=("$package")
    done

    # Check each package for conflicts
    for package in "${all_packages[@]}"; do
        local package_dir="$DOTFILES_DIR/$package"

        echo -e "${BLUE}Checking package: ${NC}$package"

        # For packages with .config subdirectories
        if [[ -d "$package_dir/.config" ]]; then
            for item in "$package_dir/.config"/*; do
                [[ ! -e "$item" ]] && continue

                local item_name=$(basename "$item")
                # Set target $HOME and source $DOTFILES_DIR+package
                local target="$TARGET_DIR/.config/$item_name"
                local source="$package_dir/.config/$item_name"

                # -L true = symlink
                if [[ -L "$target" ]]; then
                    local current_target=$(readlink -f "$target")
                    local expected_target=$(readlink -f "$source")

                    if [[ "$current_target" == "$expected_target" ]]; then
                        echo -e "  ${GREEN}✓${NC} .config/$item_name (correctly symlinked)"
                    else
                        echo -e "  ${YELLOW}⚠${NC} .config/$item_name (wrong symlink target)"
                        conflicts+=("$package:.config/$item_name")
                    fi
                elif [[ -e "$target" ]]; then
                    echo -e "  ${RED}✗${NC} .config/$item_name (exists but NOT a symlink - will backup)"
                    conflicts+=("$package:.config/$item_name")
                else
                    echo -e "  ${RED}✗${NC} .config/$item_name (missing)"
                    conflicts+=("$package:.config/$item_name")
                fi
            done
        fi

        # NOTE: special packages are those non `.config` stowed
        # they need to be manually added to the variable
        # eg. `bash` with its `.bashrc, .bash_profile`  files
        for special_pkg in "${SPECIAL_PACKAGES[@]}"; do
            if [[ "$package" == "$special_pkg" ]]; then
                for item in "$package_dir"/{.*,*}; do
                    [[ "$(basename "$item")" == "." ]] && continue
                    [[ "$(basename "$item")" == ".." ]] && continue
                    [[ "$(basename "$item")" == ".config" ]] && continue
                    [[ "$(basename "$item")" == ".git" ]] && continue
                    [[ "$(basename "$item")" == ".gitignore" ]] && continue
                    [[ ! -e "$item" ]] && continue

                    local item_name=$(basename "$item")

                    # If item is a directory, check files within it instead of the directory itself
                    if [[ -d "$item" ]]; then
                        for subitem in "$item"/{.*,*}; do
                            [[ "$(basename "$subitem")" == "." ]] && continue
                            [[ "$(basename "$subitem")" == ".." ]] && continue
                            [[ ! -e "$subitem" ]] && continue

                            local subitem_name=$(basename "$subitem")
                            local target="$TARGET_DIR/$item_name/$subitem_name"
                            local source="$subitem"

                            # -L true = symlink
                            if [[ -L "$target" ]]; then
                                local current_target=$(readlink -f "$target")
                                local expected_target=$(readlink -f "$source")

                                if [[ "$current_target" == "$expected_target" ]]; then
                                    echo -e "  ${GREEN}✓${NC} $item_name/$subitem_name (correctly symlinked)"
                                else
                                    echo -e "  ${YELLOW}⚠${NC} $item_name/$subitem_name (wrong symlink target)"
                                    conflicts+=("$package:$item_name/$subitem_name")
                                fi
                            elif [[ -e "$target" ]]; then
                                echo -e "  ${RED}✗${NC} $item_name/$subitem_name (exists but NOT a symlink - will backup)"
                                conflicts+=("$package:$item_name/$subitem_name")
                            else
                                echo -e "  ${RED}✗${NC} $item_name/$subitem_name (missing)"
                                conflicts+=("$package:$item_name/$subitem_name")
                            fi
                        done
                    else
                        # Handle regular files
                        local target="$TARGET_DIR/$item_name"
                        local source="$item"

                        # -L true = symlink
                        if [[ -L "$target" ]]; then
                            local current_target=$(readlink -f "$target")
                            local expected_target=$(readlink -f "$source")

                            if [[ "$current_target" == "$expected_target" ]]; then
                                echo -e "  ${GREEN}✓${NC} $item_name (correctly symlinked)"
                            else
                                echo -e "  ${YELLOW}⚠${NC} $item_name (wrong symlink target)"
                                conflicts+=("$package:$item_name")
                            fi
                        elif [[ -e "$target" ]]; then
                            echo -e "  ${RED}✗${NC} $item_name (exists but NOT a symlink - will backup)"
                            conflicts+=("$package:$item_name")
                        else
                            echo -e "  ${RED}✗${NC} $item_name (missing)"
                            conflicts+=("$package:$item_name")
                        fi
                    fi
                done
            fi
        done
        echo ""
    done

    # Handle FILE_LEVEL_PACKAGES separately
    for package in "${FILE_LEVEL_PACKAGES[@]}"; do
        local package_dir="$DOTFILES_DIR/$package"

        # Skip if package doesn't exist
        [[ ! -d "$package_dir" ]] && continue

        echo -e "${BLUE}Checking file-level package: ${NC}$package"

        # Look for .config subdirectory
        if [[ -d "$package_dir/.config" ]]; then
            # Use find to recursively get all files (not directories)
            while IFS= read -r -d '' source_file; do
                # Get the relative path from package_dir/.config/
                local rel_path="${source_file#$package_dir/.config/}"
                local target="$TARGET_DIR/.config/$rel_path"

                # -L true = symlink
                if [[ -L "$target" ]]; then
                    local current_target=$(readlink -f "$target")
                    local expected_target=$(readlink -f "$source_file")

                    if [[ "$current_target" == "$expected_target" ]]; then
                        echo -e "  ${GREEN}✓${NC} .config/$rel_path (correctly symlinked)"
                    else
                        echo -e "  ${YELLOW}⚠${NC} .config/$rel_path (wrong symlink target)"
                        conflicts+=("$package:.config/$rel_path")
                    fi
                elif [[ -e "$target" ]]; then
                    echo -e "  ${RED}✗${NC} .config/$rel_path (exists but NOT a symlink - will backup)"
                    conflicts+=("$package:.config/$rel_path")
                else
                    echo -e "  ${RED}✗${NC} .config/$rel_path (missing)"
                    conflicts+=("$package:.config/$rel_path")
                fi
            done < <(find "$package_dir/.config" -type f -print0)
        fi
        echo ""
    done

    # If no conflicts, we're done
    if [[ ${#conflicts[@]} -eq 0 ]]; then
        echo -e "${GREEN}All symlinks are correct! Nothing to fix.${NC}"
        return 0
    fi

    # Show conflicts
    echo -e "${YELLOW}Found ${#conflicts[@]} item(s) that need fixing${NC}"
    echo ""

    # Ask for confirmation
    local response
    read -p "Do you want to fix these by running stow? [y/N] " -n 1 -r response
    echo ""

    if [[ ! $response =~ ^[Yy]$ ]]; then
        echo "Aborted."
        return 1
    fi

    echo ""
    echo -e "${BLUE}Starting restoration...${NC}"
    echo ""

    # Get unique packages that need fixing
    local packages_to_fix=()
    for conflict in "${conflicts[@]}"; do
        local pkg="${conflict%%:*}"
        if [[ ! " ${packages_to_fix[@]} " =~ " ${pkg} " ]]; then
            packages_to_fix+=("$pkg")
        fi
    done

    # Process each package
    for package in "${packages_to_fix[@]}"; do
        echo -e "${BLUE}Processing: ${NC}$package"

        # Backup any existing non-symlink files/directories
        for conflict in "${conflicts[@]}"; do
            local pkg="${conflict%%:*}"
            local item_path="${conflict#*:}"

            if [[ "$pkg" == "$package" ]]; then
                local target="$TARGET_DIR/$item_path"

                if [[ -e "$target" && ! -L "$target" ]]; then
                    local backup="${target}.backup-$(date +%Y%m%d-%H%M%S)"
                    echo -e "  ${YELLOW}→${NC} Backing up $item_path to $(basename "$backup")"
                    mv "$target" "$backup"
                fi
            fi
        done

        # Check if this is a FILE_LEVEL_PACKAGE
        local is_file_level=false
        for flp in "${FILE_LEVEL_PACKAGES[@]}"; do
            if [[ "$package" == "$flp" ]]; then
                is_file_level=true
                break
            fi
        done

        if [[ "$is_file_level" == true ]]; then
            # Handle FILE_LEVEL_PACKAGES with individual file symlinks
            echo -e "  ${GREEN}→${NC} Creating individual file symlinks..."
            local package_dir="$DOTFILES_DIR/$package"

            if [[ -d "$package_dir/.config" ]]; then
                # Use find to recursively process all files
                while IFS= read -r -d '' source_file; do
                    # Get the relative path from package_dir/.config/
                    local rel_path="${source_file#$package_dir/.config/}"
                    local target="$TARGET_DIR/.config/$rel_path"
                    local target_dir="$(dirname "$target")"

                    # Create parent directory if needed
                    mkdir -p "$target_dir"

                    # Remove if exists and create symlink
                    rm -f "$target"
                    if ln -s "$source_file" "$target"; then
                        echo -e "    ${GREEN}✓${NC} Linked .config/$rel_path"
                    else
                        echo -e "    ${RED}✗${NC} Failed to link .config/$rel_path"
                    fi
                done < <(find "$package_dir/.config" -type f -print0)
            fi
            echo -e "  ${GREEN}✓${NC} Successfully restored $package"
        else
            # Use stow for regular packages
            # Change to dotfiles directory
            cd "$DOTFILES_DIR" || return 1

            # Unstow first (clean up any wrong symlinks)
            echo -e "  ${YELLOW}→${NC} Cleaning up old symlinks..."
            stow -D "$package" 2>/dev/null

            # Restow
            echo -e "  ${GREEN}→${NC} Creating symlinks..."
            if stow "$package"; then
                echo -e "  ${GREEN}✓${NC} Successfully restored $package"
            else
                echo -e "  ${RED}✗${NC} Failed to restore $package"
            fi
        fi

        echo ""
    done

    echo -e "${GREEN}=== Restoration complete! ===${NC}"
    echo ""
    echo "Verifying..."
    echo ""

    # Quick verification
    for conflict in "${conflicts[@]}"; do
        local pkg="${conflict%%:*}"
        local item_path="${conflict#*:}"
        local target="$TARGET_DIR/$item_path"

        if [[ -L "$target" ]]; then
            echo -e "${GREEN}✓${NC} $item_path is now a symlink"
        else
            echo -e "${RED}✗${NC} $item_path still has issues"
        fi
    done
}
