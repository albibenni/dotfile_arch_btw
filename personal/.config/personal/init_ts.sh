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

# Select project scope
_select_scope() {
    cat >&2 <<EOF
Select project scope:
1) backend (Node.js)
2) frontend (Browser)
EOF
    local choice
    read -r -p "Enter choice [1-2]: " choice </dev/tty

    case $choice in
    1) echo "backend" ;;
    2) echo "frontend" ;;
    *) echo "backend" ;; # default
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

_init_packages() {
    local pm="$1"
    local scope="$2"
    local packages=("typescript")

    if [[ "$scope" == "backend" ]]; then
        packages+=("@types/node")
        echo "Adding @types/node for backend..."
    fi

    echo "Installing ${packages[*]}..."
    local install_cmd
    case $pm in
    npm) install_cmd=(npm install -D "${packages[@]}") ;;
    yarn) install_cmd=(yarn add -D "${packages[@]}") ;;
    pnpm) install_cmd=(pnpm i -D "${packages[@]}") ;;
    bun) install_cmd=(bun add -D "${packages[@]}") ;;
    *) return 1 ;;
    esac

    if ! "${install_cmd[@]}"; then
        echo "Error: Installation failed" >&2
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

    # Get scope selection
    local scope
    scope=$(_select_scope)
    echo "Selected scope: $scope"

    _init_packageManager "$pm" || return 1
    _init_packages "$pm" "$scope" || return 1
    _initialize_git

    echo "TypeScript project initialized successfully with $pm for $scope!"
}

