#!/bin/bash

if ! command -v paru &> /dev/null; then
  sudo pacman -S --needed --noconfirm rustup git
  rustup default stable
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 -q https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"
  cd "$TEMP_DIR/paru"
  makepkg -si --noconfirm
  cd -
  rm -rf "$TEMP_DIR"
fi
