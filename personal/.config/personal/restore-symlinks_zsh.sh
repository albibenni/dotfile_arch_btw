#!/usr/bin/env zsh

# Function to restore lost symlinks using stow
# Source this file and call: restore-dotfiles-symlinks
# restore-dotfiles-symlinks() {
#     # Colors for output
#     local RED='\033[0;31m'
#     local GREEN='\033[0;32m'
#     local YELLOW='\033[1;33m'
#     local BLUE='\033[0;34m'
#     local NC='\033[0m' # No Color
#
#     # Get the dotfiles directory by resolving the real path of this script
#     local script_path
#     if [[ -n "${ZSH_VERSION:-}" ]]; then
#         # zsh: use special expansion for sourced file path
#         script_path="${(%):-%x}"
#     elif [[ -n "${BASH_SOURCE[0]:-}" ]]; then
#         # bash
#         script_path="${BASH_SOURCE[0]}"
#     else
#         # fallback
#         script_path="$0"
#     fi
#
#     # Resolve symlinks to get the real path, then go up 3 directories
#     local DOTFILES_DIR="$(cd "$(dirname "$(readlink -f "$script_path")")" && cd ../../.. && pwd)"
#     local TARGET_DIR="$HOME"
#
#     echo -e "${BLUE}=== Dotfiles Symlink Restoration Tool ===${NC}\n"
#     echo "Dotfiles directory: $DOTFILES_DIR"
#     echo "Target directory: $TARGET_DIR"
#     echo ""
#
#     # Find all stow packages (directories containing .config subdirectory)
#     local packages=()
#     local missing_symlinks=()
#
#     echo -e "${BLUE}Scanning for stow packages...${NC}"
#     for dir in "$DOTFILES_DIR"/*/; do
#         local package=$(basename "$dir")
#
#         # Skip special directories
#         [[ "$package" == ".git" ]] && continue
#         [[ "$package" == "script_install" ]] && continue
#
#         # Check if this is a stow package (has .config subdirectory)
#         if [[ -d "$dir/.config" ]]; then
#             packages+=("$package")
#
#             # Check each config directory within the package
#             for config_item in "$dir/.config"/*; do
#                 if [[ -e "$config_item" ]]; then
#                     local config_name=$(basename "$config_item")
#                     local target_path="$TARGET_DIR/.config/$config_name"
#                     local source_path="$dir/.config/$config_name"
#
#                     # Check if symlink exists and is correct
#                     if [[ -L "$target_path" ]]; then
#                         # It's a symlink - check if it points to the right place
#                         local link_target=$(readlink -f "$target_path")
#                         local expected_target=$(readlink -f "$source_path")
#
#                         if [[ "$link_target" == "$expected_target" ]]; then
#                             echo -e "${GREEN}✓${NC} $config_name (already linked correctly)"
#                         else
#                             echo -e "${YELLOW}⚠${NC} $config_name (symlink points to wrong location)"
#                             missing_symlinks+=("$package:$config_name:wrong_target")
#                         fi
#                     elif [[ -e "$target_path" ]]; then
#                         # Path exists but is not a symlink
#                         echo -e "${RED}✗${NC} $config_name (exists but is NOT a symlink)"
#                         missing_symlinks+=("$package:$config_name:not_symlink")
#                     else
#                         # Doesn't exist at all
#                         echo -e "${RED}✗${NC} $config_name (missing)"
#                         missing_symlinks+=("$package:$config_name:missing")
#                     fi
#                 fi
#             done
#         fi
#     done
#
#     echo ""
#
#     # If no issues found, return
#     if [[ ${#missing_symlinks[@]} -eq 0 ]]; then
#         echo -e "${GREEN}All symlinks are in place! Nothing to restore.${NC}"
#         return 0
#     fi
#
#     # Show summary
#     echo -e "${YELLOW}Found ${#missing_symlinks[@]} configuration(s) that need attention:${NC}"
#     echo ""
#
#     local packages_to_restow=()
#     for item in "${missing_symlinks[@]}"; do
#         local package config_name issue_type
#         IFS=':' read -r package config_name issue_type <<< "$item"
#
#         case "$issue_type" in
#             not_symlink)
#                 echo -e "  ${RED}•${NC} $config_name (package: $package) - exists as directory/file, needs to be replaced with symlink"
#                 ;;
#             missing)
#                 echo -e "  ${RED}•${NC} $config_name (package: $package) - missing entirely"
#                 ;;
#             wrong_target)
#                 echo -e "  ${YELLOW}•${NC} $config_name (package: $package) - symlink points to wrong location"
#                 ;;
#         esac
#
#         # Track unique packages that need restowing
#         if [[ ! " ${packages_to_restow[@]} " =~ " ${package} " ]]; then
#             packages_to_restow+=("$package")
#         fi
#     done
#
#     echo ""
#     echo -e "${YELLOW}Packages that will be restowed: ${packages_to_restow[*]}${NC}"
#     echo ""
#
#     # Ask for confirmation
#     local response
#     if [[ -n "${ZSH_VERSION:-}" ]]; then
#         # zsh syntax
#         read -k 1 "response?Do you want to restore these symlinks using stow? [y/N] "
#         echo ""
#     else
#         # bash syntax
#         read -p "Do you want to restore these symlinks using stow? [y/N] " -n 1 -r response
#         echo ""
#     fi
#
#     if [[ ! $response =~ ^[Yy]$ ]]; then
#         echo "Aborted."
#         return 1
#     fi
#
#     echo ""
#     echo -e "${BLUE}Starting restoration process...${NC}"
#     echo ""
#
#     # Process each package that needs restowing
#     for package in "${packages_to_restow[@]}"; do
#         echo -e "${BLUE}Processing package: $package${NC}"
#
#         # First, we need to handle existing non-symlink directories
#         for item in "${missing_symlinks[@]}"; do
#             local pkg config_name issue_type
#             IFS=':' read -r pkg config_name issue_type <<< "$item"
#
#             if [[ "$pkg" == "$package" && "$issue_type" == "not_symlink" ]]; then
#                 local target_path="$TARGET_DIR/.config/$config_name"
#                 local backup_path="$TARGET_DIR/.config/${config_name}.backup-$(date +%Y%m%d-%H%M%S)"
#
#                 echo -e "  ${YELLOW}→${NC} Moving $config_name to $backup_path"
#                 mv "$target_path" "$backup_path"
#             fi
#         done
#
#         # Unstow first (in case of wrong targets)
#         echo -e "  ${YELLOW}→${NC} Unstowing $package (cleaning up old symlinks)"
#         stow -D -d "$DOTFILES_DIR" -t "$TARGET_DIR" "$package" 2>/dev/null
#
#         # Restow
#         echo -e "  ${GREEN}→${NC} Restowing $package"
#         if stow -d "$DOTFILES_DIR" -t "$TARGET_DIR" "$package"; then
#             echo -e "  ${GREEN}✓${NC} Successfully restowed $package"
#         else
#             echo -e "  ${RED}✗${NC} Failed to restow $package"
#         fi
#
#         echo ""
#     done
#
#     echo -e "${GREEN}=== Restoration complete! ===${NC}"
#     echo ""
#     echo "Verifying results..."
#
#     # Verify the results
#     for item in "${missing_symlinks[@]}"; do
#         local package config_name issue_type
#         IFS=':' read -r package config_name issue_type <<< "$item"
#         local target_path="$TARGET_DIR/.config/$config_name"
#
#         if [[ -L "$target_path" ]]; then
#             echo -e "${GREEN}✓${NC} $config_name is now a symlink"
#         else
#             echo -e "${RED}✗${NC} $config_name still has issues"
#         fi
#     done
# }
