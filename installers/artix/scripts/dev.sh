#!/bin/bash
echo -e "\n=== Development Tools ==="
sudo pacman -S --needed --noconfirm \
  python python-pip uv \
  nodejs npm \
  go \
  rustup \
  clang llvm gcc \
  cmake ninja \
  docker docker-compose \
  nvim \
  github-cli \
  difftastic \
  ripgrep \
  fd \
  eza \
  kitty \
  ghostty \
  fzf \
  git wget curl \
  zip unzip tar \
  less \
  tree-sitter-cli \
  wl-clipboard

rustup default stable

sudo systemctl enable --now docker
sudo usermod -aG docker $USER
