#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Arch Linux Setup ==="
echo "This will install and configure your system in stages."
echo ""

source "$SCRIPT_DIR/scripts/system.sh"
source "$SCRIPT_DIR/scripts/dev.sh"
source "$SCRIPT_DIR/scripts/gaming.sh"
source "$SCRIPT_DIR/scripts/shell.sh"
source "$SCRIPT_DIR/scripts/assets.sh"

echo -e "\n✓ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run: dotbot -c linux.install.yaml"
echo "  2. Reboot"
echo "  3. Configure prompt: tide configure"
echo "  4. GitHub login: gh auth login"
echo "  5. Git config:"
echo "       git config --global user.name 'Your Name'"
echo "       git config --global user.email 'your@email.com'"
echo "  6. Setup displays: nwg-displays"
echo "  7. Install DMS: curl -fsSL https://install.danklinux.com | sh"
