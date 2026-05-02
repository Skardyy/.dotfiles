#!/usr/bin/env bash
set -e

REPO="https://github.com/Skardyy/assets"
DEST="$HOME/Pictures"

if [ -d "$DEST/.git" ]; then
  echo "updating $DEST..."
  git -C "$DEST" pull
else
  echo "cloning $REPO -> $DEST..."
  git clone "$REPO" "$DEST" --depth 1
fi

echo "done"
