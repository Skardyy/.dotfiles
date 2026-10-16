#!/usr/bin/env bash
set -e

HOST="${1:?usage: $0 <hostname>}"
DIR="$(dirname "$0")/../hosts/$HOST"

mkdir -p "$DIR"
sudo nixos-generate-config --show-hardware-config > "$DIR/hardware.nix"
echo "wrote $DIR/hardware.nix"
