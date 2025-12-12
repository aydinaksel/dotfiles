#!/bin/zsh

MACOS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -f "$MACOS_DIR/Brewfile" ]]; then
    echo "Installing apps from Brewfile..."
    brew bundle --file="$MACOS_DIR/Brewfile"
else
    echo "Error: Brewfile not found at $MACOS_DIR/Brewfile"
    exit 1
fi
