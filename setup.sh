#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Detecting operating system..."

case "$(uname -s)" in
    Darwin)
        echo "macOS detected"
        source "$DOTFILES_DIR/macos/setup.sh"
        ;;
    Linux)
        echo "Linux detected"
        source "$DOTFILES_DIR/linux/setup.sh"
        ;;
    *)
        echo "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac
