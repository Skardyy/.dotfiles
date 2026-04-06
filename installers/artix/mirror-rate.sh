#!/bin/bash

set -e

echo -e "\n=== Mirror List Setup ==="

DATE=$(date +%d%m%Y_%H%M%S)

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak.$DATE
sudo cp /etc/pacman.d/mirrorlist-arch /etc/pacman.d/mirrorlist-arch.bak.$DATE

rate-mirrors artix | tee /dev/tty | grep '^Server' | sudo tee /etc/pacman.d/mirrorlist
rate-mirrors arch | tee /dev/tty | grep '^Server' | sudo tee /etc/pacman.d/mirrorlist-arch
