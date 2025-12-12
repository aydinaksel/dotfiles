#!/bin/bash

set -e

LINUX_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$LINUX_DIR")"

echo "Starting Linux setup..."
echo "========================"

echo -e "\n[1/2] Symlinking dotfiles..."
ln -sf "$LINUX_DIR/.bashrc" ~/.bashrc
ln -sf "$LINUX_DIR/.profile" ~/.profile
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

echo -e "\n[2/2] Sourcing profile..."
source ~/.profile

echo -e "\n========================"
echo "Linux setup complete!"
