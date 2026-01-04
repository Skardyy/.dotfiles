#!/bin/bash
echo -e "\n=== Gaming Setup ==="
sudo pacman -S --needed --noconfirm \
  steam \
  gamemode lib32-gamemode \
  umu-launcher

sudo usermod -aG gamemode $USER
