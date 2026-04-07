#!/bin/bash

sudo pacman -S --needed --noconfirm \
  xdg-desktop-portal-gnome \
  nwg-look \
  hyprpicker \
  satty \
  nautilus \
  adw-gtk3 \
  qemu-desktop \
  ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji

paru -S --needed --noconfirm \
  quickshell \
  brave-bin \
  kanata \
  dotbot \
  quickemu \
  bibata-cursor-theme-bin

echo "  ================================================"
echo "  Bar:"
echo "      curl -fsSL https://install.danklinux.com | sh"
echo "  ================================================"
