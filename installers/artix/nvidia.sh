#!/bin/bash

set -e

echo -e "\n=== Nvidia Setup ==="

sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils lib32-nvidia-utils

echo "============================================================="
echo "Edit /etc/mkinitcpio.conf"
echo "add to MODULES=(... nvidia_modeset nvidia_uvm nvidia_drm)"
echo "============================================================="
echo "Edit /etc/default/grub"
echo "add to GRUB_CMDLINE_LINUX_DEFAULT='... nvidia_drm.modeset=1'"
echo "============================================================="
echo "Call"
echo "sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo "sudo mkinitcpio -P"
echo "============================================================="
