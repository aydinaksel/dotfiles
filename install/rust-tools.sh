#!/bin/bash

set -euo pipefail

export OPENSSL_NO_VENDOR=1

RUSTUP_BINARY="$HOME/.local/bin/rustup"
RUSTUP_URL="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"

tools=(
    cargo-leptos
    bat
    qrrs
    rustlings
    syntaqlite-cli
    mdbook
    ripgrep
    starship
    tree-sitter-cli
    xh
    nu
    gitui
    du-dust
    zellij
)

gui_tools=(
    alacritty
)

if [[ "$OSTYPE" == "darwin"* ]] || command -v Xorg &>/dev/null || command -v Xwayland &>/dev/null; then
    tools+=("${gui_tools[@]}")
else
    echo "Headless system detected; skipping GUI tools: ${gui_tools[*]}"
fi

echo "Ensuring rustup is installed and up to date..."
mkdir -p "$(dirname "$RUSTUP_BINARY")"
curl --proto '=https' --tlsv1.2 -sSf "$RUSTUP_URL" -o "$RUSTUP_BINARY"
chmod +x "$RUSTUP_BINARY"

"$RUSTUP_BINARY" default stable >/dev/null 2>&1 || "$RUSTUP_BINARY" toolchain install stable
"$RUSTUP_BINARY" update
"$RUSTUP_BINARY" component add rust-analyzer

if ! command -v cargo &>/dev/null; then
    echo "cargo not found on PATH; ensure $HOME/.cargo/bin is in PATH" >&2
    exit 1
fi

declare -A desired
for tool in "${tools[@]}"; do
    desired[$tool]=1
done

installed=$(cargo install --list | awk '/^[^ ]/ {sub(/ v.*:$/, ""); print}')

for package in $installed; do
    if [[ -z "${desired[$package]:-}" ]]; then
        echo "  -- uninstalling $package"
        cargo uninstall "$package"
    fi
done

for tool in "${tools[@]}"; do
    echo "  -> $tool"
    cargo install --locked "$tool"
done

echo "Rust tools synced."
