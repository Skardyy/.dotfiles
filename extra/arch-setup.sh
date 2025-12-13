#!/bin/bash

set -e

TEMP_DIR=$(mktemp -d)

echo -e "\n[1/7] Installing core utilities..."
sudo pacman -S --needed --noconfirm \
  git \
  github-cli \
  nvim \
  zip unzip tar \
  fd \
  fzf \
  fish \
  ripgrep \
  wget curl \
  less \
  difftastic

echo -e "\n[2/7] Installing development tools and compilers..."
sudo pacman -S --needed --noconfirm \
  base-devel \
  python python-pip python-pipx \
  nodejs npm \
  go \
  umu-launcher \
  rust \
  clang llvm \
  gcc \
  cmake ninja \
  docker docker-compose

echo -e "\n[3/7] Installing fonts..."
mkdir -p "$HOME/.local/share/fonts"
wget -O "$TEMP_DIR/CommitMono.tar.gz" "https://github.com/Skardyy/fonts/releases/download/1.0.0/CommitMono.tar.gz"
wget -O "$TEMP_DIR/ZedMono.tar.gz" "https://github.com/Skardyy/fonts/releases/download/1.0.0/ZedMono.tar.gz"
tar -xzf "$TEMP_DIR/CommitMono.tar.gz" -C "$TEMP_DIR"
tar -xzf "$TEMP_DIR/ZedMono.tar.gz" -C "$TEMP_DIR"
find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$HOME/.local/share/fonts" \;
fc-cache -fv

echo -e "\n[4/7] Cloning assets repository..."
if [ -d "$HOME/Pictures/assets" ]; then
  echo "Assets already exist, pulling latest..."
  git -C "$HOME/Pictures/assets" pull
else
  mkdir -p "$HOME/Pictures"
  git clone --depth 1 https://github.com/Skardyy/assets "$HOME/Pictures/assets"
fi


echo -e "\n[5/7] Setting up yay..."
if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone --depth 1 https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

echo -e "\n[5.5/7] Configuring git..."
git config --global core.editor "nvim"
git config --global diff.external "difft"

echo -e "\n[6/7] Installing AUR packages..."
yay -S --needed --noconfirm \
  zen-browser-bin \
  bibata-cursor-theme-bin

echo -e "\n[7/7] Configuring fish shell..."
chsh -s /usr/bin/fish
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher install ilancosman/tide@v6"

rm -rf "$TEMP_DIR"

echo -e "\n✓ Setup complete!"
echo "Remember to:"
echo "  - Setup the prompt: tide configure"
echo "  - Log in to GitHub CLI: gh auth login"
echo "  - Set git credentials:"
echo "      git config --global user.name 'Your Name'"
echo "      git config --global user.email 'your@email.com'"
echo "  - Setup displays: nwg-displays"
