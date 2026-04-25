#!/bin/bash

set -e

sudo pacman -S --needed --noconfirm \
  steam \
  discord \
  gamemode lib32-gamemode \
  umu-launcher

paru -S qt5-webchannel
paru -S qt5-webengine
paru -S stremio

sudo groupadd gamemode
sudo usermod -aG gamemode $USER
