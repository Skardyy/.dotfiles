#!/usr/bin/env bash

check_packages() {
  if pacman -Qi "$1" &>/dev/null; then
    printf "\033[1;33m%s is already installed.\033[0m\n" "$1"
  else
    printf "\033[1;32mInstalling %s...\033[0m\n" "$1"
    sudo pacman -S --noconfirm "$1"
  fi
}

install_dependencies() {
  printf "\n\033[1;32mInstalling dependencies...\033[0m\n"

  DEPENDENCIES=(
    bluez-utils \
    brightnessctl \
    hyprlock \
    pipewire \
    pipewire-pulse \
    python \
    ttf-jetbrains-mono-nerd \
    wireplumber \
    hyprlock \
    # rofi may be needed idk
  )

  for PACKAGE in "${DEPENDENCIES[@]}"; do
    check_packages "$PACKAGE"
  done
}

check_aur_packages() {
  AUR_HELPER=$(get_aur_helper)

  if $AUR_HELPER -Qi "$1" &>/dev/null; then
    printf "\033[1;33m%s (AUR) is already installed.\033[0m\n" "$1"
  else
    printf "\033[1;32mInstalling %s (AUR)...\033[0m\n" "$1"
    $AUR_HELPER -S --noconfirm "$1"
  fi
}

install_aur_packages() {
  printf "\n\033[1;32mUsing %s to install AUR packages...\033[0m\n" "$(get_aur_helper)"
  check_aur_packages bluetui
  check_aur_packages rofi-lbonn-wayland-git
}

setup_scripts() {
  printf "\n\033[1;32mSetting up scripts...\033[0m\n"

  chmod +x ~/.config/waybar/scripts/*
}

install_dependencies
install_aur_packages
setup_scripts
