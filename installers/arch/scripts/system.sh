#!/bin/bash
echo -e "\n=== System Packages ==="

# yay
if ! command -v yay &> /dev/null; then
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 -q https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"
  cd "$TEMP_DIR/yay"
  makepkg -si --noconfirm
  cd -
  rm -rf "$TEMP_DIR"
fi

sudo pacman -S --needed --noconfirm \
  xdg-desktop-portal-gnome \
  nwg-displays \
  nwg-look \
  hyprpicker \
  satty \
  nautilus \
  qemu-desktop \
  mission-center

yay -S --needed --noconfirm \
  quickshell \
  brave-bin \
  flat-remix-gtk \
  dotbot \
  quickemu \
  bibata-cursor-theme-bin

echo "Enabling services..."
sudo systemctl enable --now bluetooth
