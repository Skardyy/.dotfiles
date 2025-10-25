<div align=center>
  
  # My dotfiles

  minimal dotfiles for neovim and hyprland with ahk scripts for windows  
  
  [![Static Badge](https://img.shields.io/badge/Hyprland-1C1F2E?style=for-the-badge&logo=hyprland)](./hypr)
  [![Static Badge](https://img.shields.io/badge/Neovim-1C1F2E?style=for-the-badge&logo=neovim)](./editors/nvim)
  [![Static Badge](https://img.shields.io/badge/Makurai%20Theme-1C1F2E?style=for-the-badge&logo=codefactor)](https://github.com/Skardyy/makurai-theme)

</div>
    
| Desktop | Neovim |
|---------|---------|
| ![image](https://github.com/user-attachments/assets/b58e957a-22c8-44a0-b463-1a66519cf730) | ![image](https://github.com/user-attachments/assets/3a52e1f3-9ea8-4f1b-b249-2e43c16d6d29) |


> [!Note]
> 
> I install the dotfiles using [dotbot](https://github.com/anishathalye/dotbot)  
> but configuring it differently or using a different dotfiles manager should be rather easy --  
> the [windows installer](./windows.install.yaml) and [linux installer](./linux.install.yaml) tell you everything on what should be where

> [!Tip]
>
> the dotfiles are based on [end4 dotfiles](https://github.com/end-4/dots-hyprland)

# Install  
```sh
pip install dotbot
git clone https://github.com/Skardyy/.dotfiles ~/.dotfiles
cd ~/.dotfiles

sudo dotbot -c windows.install.yaml
or ~
dotbot -c linux.install.yaml
```  
