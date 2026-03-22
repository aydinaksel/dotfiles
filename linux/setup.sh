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
mkdir -p ~/.config/fish/functions
ln -sf "$LINUX_DIRECTORY/config.fish" ~/.config/fish/config.fish
for file in "$LINUX_DIRECTORY/fish_functions/"*.fish; do
    ln -sf "$file" ~/.config/fish/functions/"$(basename "$file")"
done
mkdir -p ~/.config/tmux
ln -sf "$LINUX_DIRECTORY/tmux.conf" ~/.config/tmux/tmux.conf

echo -e "\n[2/3] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIRECTORY/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIRECTORY/.claude/settings.json" ~/.claude/settings.json

echo -e "\n[3/3] Sourcing profile..."
source ~/.profile

echo -e "\n========================"
echo "Linux setup complete!"
