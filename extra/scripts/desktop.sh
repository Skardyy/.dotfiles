#!/bin/bash
echo -e "\n=== Desktop Environment ==="
sudo pacman -S --needed --noconfirm \
  xdg-desktop-portal-gnome \
  nwg-displays \
  hyprpicker \
  libimobiledevice ifuse \
  nemo \
  mission-center

echo "Enabling services..."
sudo systemctl enable --now bluetooth
