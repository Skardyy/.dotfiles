#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Artix Setup ==="

if ! command -v paru &> /dev/null; then
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 -q https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"
  cd "$TEMP_DIR/paru"
  makepkg -si --noconfirm
  cd -
  rm -rf "$TEMP_DIR"
fi
