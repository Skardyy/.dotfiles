#!/bin/bash
echo -e "\n=== Assets ==="

# Fonts
TEMP_DIR=$(mktemp -d)
mkdir -p "$HOME/.local/share/fonts"

wget -q -O "$TEMP_DIR/CommitMono.tar.gz" \
  "https://github.com/Skardyy/fonts/releases/download/1.0.0/CommitMono.tar.gz"
wget -q -O "$TEMP_DIR/ZedMono.tar.gz" \
  "https://github.com/Skardyy/fonts/releases/download/1.0.0/ZedMono.tar.gz"

tar -xzf "$TEMP_DIR/CommitMono.tar.gz" -C "$TEMP_DIR"
tar -xzf "$TEMP_DIR/ZedMono.tar.gz" -C "$TEMP_DIR"

find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) \
  -exec cp {} "$HOME/.local/share/fonts" \;

fc-cache -fv
rm -rf "$TEMP_DIR"

# Images
if [ -d "$HOME/Pictures/assets" ]; then
  git -C "$HOME/Pictures/assets" pull -q
else
  mkdir -p "$HOME/Pictures"
  git clone --depth 1 -q https://github.com/Skardyy/assets "$HOME/Pictures/assets"
fi
