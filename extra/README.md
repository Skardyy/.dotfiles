<details>
  <summary>🐧 Linux</summary>

  ---
  ### Arch-setup  
  ```sh
  chmod +x ./arch-setup.sh
  ./arch-setup.sh
  ```

  ### Wayland Nvidia shi
  ```sh
  sudo pacman -S libva-nvidia-driver
  sudo vim /etc/default/grub
  GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  reboot
  ```

  ### Colloid-gtk-theme
  ```sh
  git clone https://github.com/vinceliuice/Colloid-gtk-theme
  cd Colloid-gtk-theme
  ./install.sh --theme all --tweaks dracula black
  
  finally run nwg-look and set it.
  ```

  ### install fish
  ```sh
  sudo pacman -S fish
  chsh -s /usr/bin/fish
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
  fisher install ilancosman/tide
  ```
  ---
</details>

<details>
  <summary>🪟 Windows</summary>

  ---
  ### Winutil
  * open a terminal on admin
  * run `irm "https://christitus.com/win" | iex`
  * import the [winutil config](https://github.com/Skardyy/.dotfiles/blob/main/prerequisites/winutil.json)

  ### AltDrag
  * goto [AltDrag website](https://stefansundin.github.io/altdrag/) 

  ### Rhiza
  ```sh
  cargo install rhiza  
  ```

  ### Cursor
  * goto [jepri w11cc](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)

  ---
</details>


