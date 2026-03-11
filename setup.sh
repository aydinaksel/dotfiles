#!/bin/bash

set -e

DOTFILES_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Detecting operating system..."

case "$(uname -s)" in
    Darwin)
        echo "macOS detected"
        source "$DOTFILES_DIRECTORY/macos/setup.sh"
        ;;
    Linux)
        echo "Linux detected"
        source "$DOTFILES_DIRECTORY/linux/setup.sh"
        ;;
    *)
        echo "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac
