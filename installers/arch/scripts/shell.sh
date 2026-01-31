#!/bin/bash
echo -e "\n=== Shell Configuration ==="
sudo pacman -S --needed --noconfirm fish

if [ "$SHELL" != "/usr/bin/fish" ]; then
  chsh -s /usr/bin/fish
  echo "Shell changed to fish (takes effect on next login)"
else
  echo "Fish is already the default shell"
fi

fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher install ilancosman/tide@v6"
