#!/bin/bash

set -e

LINUX_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIRECTORY="$(dirname "$LINUX_DIRECTORY")"

echo "Starting Linux setup..."
echo "========================"

echo -e "\n[1/3] Symlinking dotfiles..."
ln -sf "$LINUX_DIRECTORY/.bashrc" ~/.bashrc
ln -sf "$LINUX_DIRECTORY/.profile" ~/.profile
mkdir -p ~/.config/git
ln -sf "$DOTFILES_DIRECTORY/git/config" ~/.config/git/config
ln -sf "$LINUX_DIRECTORY/starship.toml" ~/.config/starship.toml

echo -e "\n[2/3] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIRECTORY/.claude/CLAUDE.md" ~/.claude/CLAUDE.md

echo -e "\n[3/3] Sourcing profile..."
source ~/.profile

echo -e "\n========================"
echo "Linux setup complete!"
