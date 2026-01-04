#!/bin/bash
echo -e "\n=== Development Tools ==="
sudo pacman -S --needed --noconfirm \
  python python-pip python-pipx \
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
  fzf

rustup default stable
if ! command -v dotbot &> /dev/null; then
  pipx install dotbot
  pipx ensurepath
  source ~/.bashrc
fi

git config --global core.editor "nvim"
git config --global diff.external "difft"

sudo systemctl enable --now docker
sudo usermod -aG docker $USER
