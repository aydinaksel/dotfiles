#!/bin/bash

set -e

echo "Installing packages on Debian..."

sudo apt update

sudo apt install -y \
    git \
    neovim

# Rust
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# ripgrep via cargo
cargo install ripgrep

echo "Debian packages installed."
