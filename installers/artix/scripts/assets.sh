#!/bin/bash
echo -e "\n=== Assets ==="

# Fonts
mkdir -p "$HOME/.local/share/fonts"
FONTS_UPDATED=0

if ! ls "$HOME/.local/share/fonts"/CommitMono* &>/dev/null; then
  TEMP_DIR=$(mktemp -d)
  curl -sL -o "$TEMP_DIR/CommitMono.tar.gz" \
    "https://github.com/Skardyy/fonts/releases/download/1.0.0/CommitMono.tar.gz" && \
  tar -xzf "$TEMP_DIR/CommitMono.tar.gz" -C "$TEMP_DIR" && \
  find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) \
    -exec cp {} "$HOME/.local/share/fonts" \; && \
  echo "CommitMono installed" || echo "CommitMono install failed"
  rm -rf "$TEMP_DIR"
  FONTS_UPDATED=1
else
  echo "CommitMono already installed, skipping"
fi

if ! ls "$HOME/.local/share/fonts"/ZedMono* &>/dev/null; then
  TEMP_DIR=$(mktemp -d)
  curl -sL -o "$TEMP_DIR/ZedMono.tar.gz" \
    "https://github.com/Skardyy/fonts/releases/download/1.0.0/ZedMono.tar.gz" && \
  tar -xzf "$TEMP_DIR/ZedMono.tar.gz" -C "$TEMP_DIR" && \
  find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) \
    -exec cp {} "$HOME/.local/share/fonts" \; && \
  echo "ZedMono installed" || echo "ZedMono install failed"
  rm -rf "$TEMP_DIR"
  FONTS_UPDATED=1
else
  echo "ZedMono already installed, skipping"
fi

[ $FONTS_UPDATED -eq 1 ] && fc-cache -fv

# Images
if [ -d "$HOME/Pictures/assets" ]; then
  echo "Assets already cloned, skipping"
else
  mkdir -p "$HOME/Pictures"
  git clone --depth 1 -q https://github.com/Skardyy/assets "$HOME/Pictures/assets" && \
  echo "Assets cloned" || echo "Assets clone failed"
fi
