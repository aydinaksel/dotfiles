#!/bin/bash

set -e

echo "Installing Rust tools..."

if ! command -v cargo &>/dev/null; then
    echo "cargo not found. Install Rust via rustup first: https://rustup.rs"
    exit 1
fi

tools=(
    cargo-leptos
    mdbook
    ripgrep
    starship
    tree-sitter-cli
)

for tool in "${tools[@]}"; do
    echo "  -> $tool"
    cargo install "$tool"
done

echo "Rust tools installed."
