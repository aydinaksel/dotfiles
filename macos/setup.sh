#!/bin/zsh

set -e

MACOS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting macOS setup..."
echo "========================"

echo "\n[1/2] Setting up Homebrew..."
source "$MACOS_DIR/scripts/brew.sh"

echo "\n[2/2] Installing applications..."
source "$MACOS_DIR/scripts/apps.sh"

echo "\n========================"
echo "macOS setup complete!"
