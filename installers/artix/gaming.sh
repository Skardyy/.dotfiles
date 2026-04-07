#!/bin/bash

set -e

sudo pacman -S --needed --noconfirm \
  steam \
  discord \
  gamemode lib32-gamemode \
  umu-launcher

sudo groupadd gamemode
sudo usermod -aG gamemode $USER
