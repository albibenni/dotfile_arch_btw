#! /bin/bash

#TODO: handle yarn pnpm npm with vars
tsInit() {
    echo "Initializing TypeScript project..."
    if ! init=$(pnpm init 2>&1); then
        echo "Error: pnpm init failed"
        echo "$init"
        return 1
    fi
    echo "$init"

    echo "Installing TypeScript..."
    if ! typescript=$(pnpm i -D typescript 2>&1); then
        echo "Error: TypeScript installation failed"
        return 1
    fi
    echo "$typescript"

    echo "Creating tsconfig.json..."
    if ! tsc_init=$(./node_modules/.bin/tsc --init 2>&1); then
        echo "Error: tsc --init failed"
        return 1
    fi
    echo "$tsc_init"

    echo "TypeScript project initialized successfully!"
}
