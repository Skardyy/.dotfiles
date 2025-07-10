### Arch-setup  
```sh
chmod +x ./arch-setup.sh
./arch-setup.sh
```

### Wayland Nvidia shi
```
sudo pacman -S libva-nvidia-driver
sudo vim /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

### Winutil (windows only)
* open a terminal on admin
* run `irm "https://christitus.com/win" | iex`
* import the [winutil config](https://github.com/Skardyy/.dotfiles/blob/main/prerequisites/winutil.json)

### Fonts  
* goto [nerd repo](https://github.com/ryanoasis/nerd-fonts/releases/latest)
* I like CascadiaCode  

### install altDrag (windows only)
* goto [AltDrag website](https://stefansundin.github.io/altdrag/)  

### Rhiza (windows only)  
```pwsh
cargo install rhiza  
```

### mcat
```pwsh
cargo install mcat  
```

## Cursor
* goto [jepri w11cc](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)

### install fish (linux only)
```bash
sudo pacman -S fish
chsh -s /usr/bin/fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install ilancosman/tide
```
