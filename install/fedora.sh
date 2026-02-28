#!/bin/bash

set -e

echo "Installing packages on Fedora..."

sudo dnf install -y \
    git \
    neovim \
    python3 \
    ripgrep \
    lua-language-server \
    rust-analyzer \
    python3-ruff \
    gh

echo "Fedora packages installed."
