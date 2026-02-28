#!/bin/zsh

set -e

MACOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIR="$(dirname "$MACOS_DIR")"

echo "Starting macOS setup..."
echo "========================"

echo -e "\n[1/2] Installing packages..."
source "$DOTFILES_DIR/install/macos.sh"

echo -e "\n[2/2] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md

echo -e "\n========================"
echo "macOS setup complete!"
