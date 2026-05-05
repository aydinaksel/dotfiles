#!/bin/zsh

set -e

MACOS_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DOTFILES_DIRECTORY="$(dirname "$MACOS_DIRECTORY")"

echo "Starting macOS setup..."
echo "========================"

echo -e "\n[1/2] Installing packages..."
source "$DOTFILES_DIRECTORY/install/macos.sh"

SHARED_DIRECTORY="$DOTFILES_DIRECTORY/linux"

echo -e "\n[2/3] Symlinking dotfiles..."
ln -sf "$MACOS_DIRECTORY/.zshenv" ~/.zshenv
ln -sf "$MACOS_DIRECTORY/.zshrc" ~/.zshrc
mkdir -p ~/.config/git
ln -sf "$DOTFILES_DIRECTORY/git/config" ~/.config/git/config
ln -sf "$SHARED_DIRECTORY/starship.toml" ~/.config/starship.toml
mkdir -p ~/.config/alacritty/themes
ln -sf "$SHARED_DIRECTORY/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
for file in "$SHARED_DIRECTORY/alacritty/themes/"*.toml; do
    ln -sf "$file" ~/.config/alacritty/themes/"$(basename "$file")"
done
mkdir -p ~/Library/Application\ Support/nushell/autoload
ln -sf "$SHARED_DIRECTORY/nu/env.nu" ~/Library/Application\ Support/nushell/env.nu
ln -sf "$SHARED_DIRECTORY/nu/config.nu" ~/Library/Application\ Support/nushell/config.nu
for file in "$SHARED_DIRECTORY/nu/autoload/"*.nu; do
    ln -sf "$file" ~/Library/Application\ Support/nushell/autoload/"$(basename "$file")"
done
mkdir -p ~/.config/nushell/autoload
ln -sf "$SHARED_DIRECTORY/nu/env.nu" ~/.config/nushell/env.nu
ln -sf "$SHARED_DIRECTORY/nu/config.nu" ~/.config/nushell/config.nu
for file in "$SHARED_DIRECTORY/nu/autoload/"*.nu; do
    ln -sf "$file" ~/.config/nushell/autoload/"$(basename "$file")"
done
mkdir -p ~/.config/zellij
ln -sf "$SHARED_DIRECTORY/zellij/config.kdl" ~/.config/zellij/config.kdl
mkdir -p ~/.config/gitui
for file in "$SHARED_DIRECTORY/gitui/"*.ron; do
    ln -sf "$file" ~/.config/gitui/"$(basename "$file")"
done
ln -sf "$SHARED_DIRECTORY/gitui/catppuccin-macchiato.ron" ~/.config/gitui/theme.ron

echo -e "\n[3/3] Symlinking Claude config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIRECTORY/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_DIRECTORY/.claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES_DIRECTORY/.claude/settings.local.json" ~/.claude/settings.local.json
ln -sf "$DOTFILES_DIRECTORY/.claude/statusline-command.sh" ~/.claude/statusline-command.sh

echo -e "\n========================"
echo "macOS setup complete!"
