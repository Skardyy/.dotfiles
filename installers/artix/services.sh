sudo pacman -S --needed --noconfirm turnstile-dinit

sudo dinitctl enable turnstiled

sudo pacman -S --needed --noconfirm pipewire-dinit wireplumber-dinit pipewire-pulse-dinit pipewire-bluetooth
dinitctl --user enable pipewire
dinitctl --user enable wireplumber
dinitctl --user enable pipewire-pulse
