#! /bin/bash

# Select package manager
selectPackageManager() {
    echo "Select package manager:" >&2
    echo "1) npm" >&2
    echo "2) yarn" >&2
    echo "3) pnpm" >&2
    echo "4) bun" >&2
    echo -n "Enter choice [1-4]: " >&2
    read choice </dev/tty

    case $choice in
        1) echo "npm" ;;
        2) echo "yarn" ;;
        3) echo "pnpm" ;;
        4) echo "bun" ;;
        *) echo "pnpm" ;; # default
    esac
}

initializeGit() {
    if [ -d .git ]; then
        echo "Git repository already initialized"
    else
        echo -n "Initialize Git? [y/n]: "
        read is_git </dev/tty
        if [ "$is_git" = "y" ] || [ "$is_git" = "Y" ]; then
            echo "Initializing git repository..."
            git init
        else
            echo "Skipping git initialization"
        fi
    fi
}

tsInit() {
    # Get package manager selection
    local pm="$1"
    if [ -z "$pm" ]; then
        pm=$(selectPackageManager)
    fi
    echo "Using package manager: $pm"

    echo "Initializing TypeScript project..."
    case $pm in
        npm)
            if ! init=$(npm init -y 2>&1); then
                echo "Error: npm init failed"
                echo "$init"
                return 1
            fi
            ;;
        yarn)
            if ! init=$(yarn init -y 2>&1); then
                echo "Error: yarn init failed"
                echo "$init"
                return 1
            fi
            ;;
        pnpm)
            if ! init=$(pnpm init 2>&1); then
                echo "Error: pnpm init failed"
                echo "$init"
                return 1
            fi
            ;;
        bun)
            if ! init=$(bun init -y 2>&1); then
                echo "Error: bun init failed"
                echo "$init"
                return 1
            fi
            ;;
    esac
    echo "$init"

    echo "Installing TypeScript..."
    case $pm in
        npm)
            if ! typescript=$(npm install -D typescript 2>&1); then
                echo "Error: TypeScript installation failed"
                return 1
            fi
            ;;
        yarn)
            if ! typescript=$(yarn add -D typescript 2>&1); then
                echo "Error: TypeScript installation failed"
                return 1
            fi
            ;;
        pnpm)
            if ! typescript=$(pnpm i -D typescript 2>&1); then
                echo "Error: TypeScript installation failed"
                return 1
            fi
            ;;
        bun)
            if ! typescript=$(bun add -D typescript 2>&1); then
                echo "Error: TypeScript installation failed"
                return 1
            fi
            ;;
    esac
    echo "$typescript"

    echo "Creating tsconfig.json..."
    if ! tsc_init=$(./node_modules/.bin/tsc --init 2>&1); then
        echo "Error: tsc --init failed"
        return 1
    fi
    echo "$tsc_init"

    initializeGit

    echo "TypeScript project initialized successfully with $pm!"
}
