#!/usr/bin/env bash

# Select package manager
_select_package_manager() {
    cat >&2 <<EOF
Select package manager:
1) npm
2) yarn
3) pnpm
4) bun
EOF
    local choice
    read -r -p "Enter choice [1-4]: " choice </dev/tty

    case $choice in
    1) echo "npm" ;;
    2) echo "yarn" ;;
    3) echo "pnpm" ;;
    4) echo "bun" ;;
    *) echo "pnpm" ;; # default
    esac
}

_initialize_git() {
    if [[ -d .git ]]; then
        echo "Git repository already initialized"
        return
    fi

    local is_git
    read -r -p "Initialize Git? [y/n]: " is_git </dev/tty

    if [[ ! "${is_git,,}" =~ ^y ]]; then
        echo "Skipping git initialization"
        return
    fi

    echo "Initializing git repository..."
    git init

    cat >.gitignore <<'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
build/
out/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.*.local

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Editor directories
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Testing
coverage/
.nyc_output/

# Misc
*.cache
.turbo/
EOF
}

_init_packageManager() {
    local pm="$1"
    local init_cmd

    echo "Initializing TypeScript project..."
    case $pm in
    npm) init_cmd=(npm init -y) ;;
    yarn) init_cmd=(yarn init -y) ;;
    pnpm) init_cmd=(pnpm init) ;;
    bun) init_cmd=(bun init -y) ;;
    *)
        echo "Error: Unknown package manager $pm" >&2
        return 1
        ;;
    esac

    if ! "${init_cmd[@]}"; then
        echo "Error: ${init_cmd[*]} failed" >&2
        return 1
    fi
}

_init_typescript() {
    local pm="$1"
    local install_cmd

    echo "Installing TypeScript..."
    case $pm in
    npm) install_cmd=(npm install -D typescript) ;;
    yarn) install_cmd=(yarn add -D typescript) ;;
    pnpm) install_cmd=(pnpm i -D typescript) ;;
    bun) install_cmd=(bun add -D typescript) ;;
    *) return 1 ;;
    esac

    if ! "${install_cmd[@]}"; then
        echo "Error: TypeScript installation failed" >&2
        return 1
    fi

    echo "Creating tsconfig.json..."
    if ! ./node_modules/.bin/tsc --init; then
        echo "Error: tsc --init failed" >&2
        return 1
    fi
}

tsInit() {
    # Get package manager selection
    local pm="$1"
    if [[ -z "$pm" ]]; then
        pm=$(_select_package_manager)
    fi
    echo "Using package manager: $pm"

    _init_packageManager "$pm" || return 1
    _init_typescript "$pm" || return 1
    _initialize_git

    echo "TypeScript project initialized successfully with $pm!"
}

