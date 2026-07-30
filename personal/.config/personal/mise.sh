# Function to update all global languages managed by mise
update_mise_langs() {
    echo "🔄 Updating mise plugins..."
    # mise itself is updated via the system package manager (pacman/yay)
    mise plugin update

    echo "🚀 Installing and setting the latest versions globally..."
    mise use -g node@latest
    mise use -g pnpm@latest
    mise use -g python@latest
    mise use -g go@latest
    mise use -g java@latest
    mise use -g golangci-lint@latest
    mise use -g maven@latest
    mise use -g pipx@latest

    if command -v rustup &>/dev/null; then
        echo "🦀 Updating Rust via rustup..."
        rustup update
    fi

    if command -v pipx &>/dev/null; then
        echo "🐍 Updating global Python CLI tools via pipx..."
        pipx upgrade-all
    fi

    echo "🧹 Pruning old and unused versions to free up space..."
    mise prune -y

    echo "✅ All global languages have been updated to the latest versions!"
    mise ls -g
}
