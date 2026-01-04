#!/bin/bash
echo -e "\n=== System Packages ==="
sudo pacman -S --needed --noconfirm \
  base-devel \
  git wget curl \
  zip unzip tar \
  less \
  wl-clipboard
