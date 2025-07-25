<div align=center>
  
  # My dotfiles

  minimal dotfiles for neovim and hyprland with ahk scripts for windows  
  
  [![Static Badge](https://img.shields.io/badge/Hyprland-1C1F2E?style=for-the-badge&logo=hyprland)](./hypr)
  [![Static Badge](https://img.shields.io/badge/Neovim-1C1F2E?style=for-the-badge&logo=neovim)](./editors/nvim)
  [![Static Badge](https://img.shields.io/badge/Makurai%20Theme-1C1F2E?style=for-the-badge&logo=codefactor)](https://github.com/Skardyy/makurai-theme)

</div>
    
![image](https://github.com/user-attachments/assets/966ffdd8-5662-4588-880d-46604bb48b73)

> [!Note]
> 
> I install the dotfiles using [dotbot](https://github.com/anishathalye/dotbot)  
> but configuring it differently or using a different dotfiles manager should be rather easy --  
> the [windows installer](./windows.install.yaml) and [linux installer](./linux.install.yaml) tell you everything on what should be where

> [!Tip]
>
> the notch in the config is [Ax-shell](https://github.com/Axenide/Ax-Shell)

# Install  
```sh
pip install dotbot
git clone https://github.com/Skardyy/.dotfiles ~/.dotfiles
cd ~/.dotfiles

sudo dotbot -c windows.install.yaml
or ~
dotbot -c linux.install.yaml
```  
