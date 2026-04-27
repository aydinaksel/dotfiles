#!/bin/bash

set -e

echo "Installing packages on Fedora..."

sudo dnf install -y --setopt=install_weak_deps=False \
    git \
    neovim \
    python3 \
    lua-language-server \
    python3-ruff \
    gh \
    gcc \
    make \
    cmake \
    pkg-config \
    openssl-devel \
    perl-IPC-Cmd \
    clang-devel \
    fontconfig-devel \
    freetype-devel \
    libxcb-devel

echo "Fedora packages installed."
