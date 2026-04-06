#!/bin/bash

set -e

echo -e "\n=== Nvidia Setup ==="

sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils lib32-nvidia-utils
