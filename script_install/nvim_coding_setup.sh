#!/bin/bash

sudo pacman -S nodejs npm ripgrep gcc build-essential

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup update

GO_VERSION=1.24.4
GO_TARBALL=go$GO_VERSION.linux-amd64.tar.gz
GO_URL=https://golang.org/dl/$GO_TARBALL

# Download Go tarball
curl -LO $GO_URL

# Remove any existing Go installation in /usr/local
sudo rm -rf /usr/local/go

# Extract the tarball to /usr/local
sudo tar -C /usr/local -xzf $GO_TARBALL

# (Optional) Clean up the tarball
rm $GO_TARBALL

# Add Go to PATH in current session (and suggest adding it to profile)
export PATH=$PATH:/usr/local/go/bin
echo "Go installed to /usr/local/go"
echo "Add 'export PATH=\$PATH:/usr/local/go/bin' to your ~/.bashrc or ~/.zshrc"
