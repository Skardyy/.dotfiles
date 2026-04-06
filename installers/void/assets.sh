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

# Bibata cursor theme
if [ ! -d "$HOME/.local/share/icons/Bibata-Modern-Ice" ]; then
  TEMP_DIR=$(mktemp -d)
  mkdir -p "$HOME/.local/share/icons"
  curl -sL -o "$TEMP_DIR/Bibata.tar.xz" \
    "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Ice.tar.xz" && \
  tar -xJf "$TEMP_DIR/Bibata.tar.xz" -C "$HOME/.local/share/icons/" && \
  echo "Bibata cursor installed" || echo "Bibata cursor install failed"
  rm -rf "$TEMP_DIR"
else
  echo "Bibata cursor already installed, skipping"
fi

# Flat Remix GTK theme
if [ -d "$HOME/.local/share/themes/Flat-Remix-GTK-Light" ] || [ -d "$HOME/.local/share/themes/Flat-Remix-GTK-Dark" ]; then
  echo "Flat Remix GTK already installed, skipping"
else
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 -q https://github.com/daniruiz/flat-remix-gtk "$TEMP_DIR/flat-remix-gtk" && \
  mkdir -p "$HOME/.local/share/themes" && \
  cp -r "$TEMP_DIR/flat-remix-gtk/themes/"* "$HOME/.local/share/themes/" && \
  echo "Flat Remix GTK installed" || echo "Flat Remix GTK install failed"
  rm -rf "$TEMP_DIR"
fi

# Images
if [ -d "$HOME/Pictures/assets" ]; then
  echo "Assets already cloned, skipping"
else
  mkdir -p "$HOME/Pictures"
  git clone --depth 1 -q https://github.com/Skardyy/assets "$HOME/Pictures/assets" && \
  echo "Assets cloned" || echo "Assets clone failed"
fi
