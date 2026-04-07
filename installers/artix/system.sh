#!/bin/bash
echo -e "\n=== System Packages ==="

sudo pacman -S --needed --noconfirm \
  xdg-desktop-portal-gnome \
  nwg-look \
  hyprpicker \
  satty \
  nautilus \
  qemu-desktop

paru -S --needed --noconfirm \
  quickshell \
  brave-bin \
  kanata \
  flat-remix-gtk \
  dotbot \
  quickemu \
  bibata-cursor-theme-bin

echo "  ================================================"
echo "  Bar:"
echo "      curl -fsSL https://install.danklinux.com | sh"
echo "  ================================================"
