#!/bin/zsh

set -e

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing packages on macOS..."

# Homebrew
if command -v brew &>/dev/null; then
    echo "Homebrew already installed"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

brew update
brew bundle --file="$INSTALL_DIR/Brewfile"

echo "macOS packages installed."
