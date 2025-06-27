<div align=center>
  
  # My dotfiles

  minimal dotfiles for neovim and hyprland with ahk scripts for windows  
  made with *Makurai theme*
  
  [![Static Badge](https://img.shields.io/badge/Hyprland-1C1F2E?style=for-the-badge&logo=hyprland)](./hypr)
  [![Static Badge](https://img.shields.io/badge/Neovim-1C1F2E?style=for-the-badge&logo=neovim)](./editors/nvim)
  [![Static Badge](https://img.shields.io/badge/Makurai%20Theme-1C1F2E?style=for-the-badge&logo=codefactor)](https://github.com/Skardyy/makurai-theme)



</div>

![image](https://github.com/user-attachments/assets/d6823219-cec0-4e88-92f5-821d82e3b67c)

> [!Note]
> 
> I install the dotfiles using [dotbot](https://github.com/anishathalye/dotbot)  
> but configuring it differently or using a different dotfiles manager should be rather easy --  
> the [windows installer](./windows.install.yaml) and [linux installer](./linux.install.yaml) tell you everything on what should be where

> [!Caution]
>
> the hyprland config is built using [HyDE](https://github.com/HyDE-Project/HyDE)  
> installing it without installing HyDE may lead to a broken config.  
> I'd also suggest making sure modify the installer to install only the things you want

# Install  
```sh
pip install dotbot
git clone https://github.com/Skardyy/.dotfiles ~/.dotfiles
cd ~/.dotfiles

sudo dotbot -c windows.install.yaml
or ~
dotbot -c linux.install.yaml
```  
