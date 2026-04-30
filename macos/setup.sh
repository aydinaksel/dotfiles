#!/bin/zsh

set -e

MACOS_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIRECTORY="$(dirname "$MACOS_DIRECTORY")"

echo "Starting macOS setup..."
echo "========================"

echo -e "\n[1/2] Installing packages..."
source "$DOTFILES_DIRECTORY/install/macos.sh"

echo -e "\n[2/3] Symlinking dotfiles..."
ln -sf "$MACOS_DIRECTORY/.zshenv" ~/.zshenv
ln -sf "$MACOS_DIRECTORY/.zshrc" ~/.zshrc
mkdir -p ~/.config/git
ln -sf "$DOTFILES_DIRECTORY/git/config" ~/.config/git/config

echo -e "\n[3/3] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIRECTORY/.claude/CLAUDE.md" ~/.claude/CLAUDE.md

echo -e "\n========================"
echo "macOS setup complete!"
