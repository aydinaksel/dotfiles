#!/bin/bash

set -e

DEBIAN_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIRECTORY="$(dirname "$DEBIAN_DIRECTORY")"
LINUX_DIRECTORY="$DOTFILES_DIRECTORY/linux"

echo "Starting Debian setup..."
echo "========================"

echo -e "\n[1/2] Symlinking dotfiles..."

mkdir -p ~/.config/fish/functions
ln -sf "$LINUX_DIRECTORY/config.fish" ~/.config/fish/config.fish
for file in "$LINUX_DIRECTORY/fish_functions/"*.fish; do
    ln -sf "$file" ~/.config/fish/functions/"$(basename "$file")"
done

mkdir -p ~/.config/starship
ln -sf "$LINUX_DIRECTORY/starship.toml" ~/.config/starship.toml

mkdir -p ~/.config/tmux
ln -sf "$LINUX_DIRECTORY/tmux.conf" ~/.config/tmux/tmux.conf

echo -e "\n[2/2] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIRECTORY/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIRECTORY/.claude/settings.json" ~/.claude/settings.json

echo -e "\n========================"
echo "Debian setup complete!"
