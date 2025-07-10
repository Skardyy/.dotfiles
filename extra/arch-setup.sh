#!/bin/bash

set -e

enable_service() {
  local service="$1"
  local user_service=false
  local systemctl_cmd="systemctl"
  
  # Check if second parameter indicates user service
  if [[ "$2" == "user" ]] || [[ "$2" == "--user" ]]; then
    user_service=true
    systemctl_cmd="systemctl --user"
  fi
  
  # Set appropriate prefix for sudo if system service
  local sudo_prefix=""
  if [[ "$user_service" == false ]]; then
    sudo_prefix="sudo "
  fi
  
  # Check if service exists
  if ! $systemctl_cmd list-unit-files | grep -q "^$service"; then
    echo "⚠️  Warning: Service $service does not exist"
    return 1
  fi
  
  # Enable if not enabled
  if ! $systemctl_cmd is-enabled --quiet "$service"; then
    echo "Enabling $service..."
    ${sudo_prefix}$systemctl_cmd enable "$service"
  else
    echo "✅ $service is already enabled"
  fi
  
  # Start if not active
  if ! $systemctl_cmd is-active --quiet "$service"; then
    echo "Starting $service..."
    ${sudo_prefix}$systemctl_cmd start "$service"
  else
    echo "✅ $service is already running"
  fi
  
  # Verify status
  if $systemctl_cmd is-active --quiet "$service"; then
    echo "✓ Success: $service is now active"
  else
    echo "❌ Error: Failed to start $service"
    $systemctl_cmd status "$service" --no-pager -l
    return 1
  fi
}

echo "=== Starting Hyprland Environment Setup ==="

echo -e "\n[1/6] Installing core utilities..."
sudo pacman -S --needed --noconfirm \
  git \
  nvim \
  zip unzip \
  libva-nvidia-driver \ # only if you have nvidia, im lazy to check
  fd \
  fzf \
  python-pipx

echo -e "\n[2/6] Installing Hyprland utilities..."
sudo pacman -S --needed --noconfirm \
  hypridle \
  hyprlock \
  wl-clipboard \
  hyprpicker \
  satty \
  grimblast

echo -e "\n[3/6] Installing UI components..."
sudo pacman -S --needed --noconfirm \
  waybar \
  swww \
  wofi \
  bibata-cursor-theme

echo -e "\n[4/6] Installing fonts..."
sudo pacman -S --needed --noconfirm \
  noto-fonts \
  noto-fonts-emoji \
  ttf-font-awesome \
  ttf-cascadia-code-nerd

echo -e "\n[5/6] Setting up adapters and audio..."
sudo pacman -S --needed --noconfirm \
  iwd \
  blueman bluez bluez-utils \
  pavucontrol \
  pipewire pipewire-pulse pipewire-alsa wireplumber

echo -e "\n[6/6] Installing AUR packages..."
if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone --depth 1 https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

yay -S --needed --noconfirm moka-icon-theme-git iwgtk

echo -e "\nInstalling pywal..."
pipx install pywal

# Service management
echo -e "\n=== Configuring services ==="
enable_service bluetooth
enable_service iwd
enable_service pipewire.service user
enable_service pipewire-pulse.service user
enable_service wireplumber.service user


echo -e "\n=== Setup complete! ==="
echo "You may want to reboot to ensure all services start properly."
