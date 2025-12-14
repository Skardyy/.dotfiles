<div align=center>
  
  # My dotfiles

  minimal dotfiles for neovim and niri with ahk scripts for windows  
  
  [![Static Badge](https://img.shields.io/badge/Neovim-1C1F2E?style=for-the-badge&logo=neovim)](./editors/nvim)
  [![Static Badge](https://img.shields.io/badge/Makurai%20Theme-1C1F2E?style=for-the-badge&logo=codefactor)](https://github.com/Skardyy/makurai-theme)
    
| Desktop | Neovim |
|---------|---------|
| ![image](https://github.com/user-attachments/assets/33f22c63-5fab-479c-8f9c-ec251f080a53) | ![image](https://github.com/user-attachments/assets/60e00134-8fba-49bb-98ac-27f8b020c381) |

</div>

> [!Note]
> 
> I install the dotfiles using [dotbot](https://github.com/anishathalye/dotbot)  
> but configuring it differently or using a different dotfiles manager should be rather easy --  
> the [windows installer](./windows.install.yaml) and [linux installer](./linux.install.yaml) tell you everything on what should be where

> [!Tip]
>
> the dotfiles uses [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)

# Install  
```sh
pip install dotbot
git clone https://github.com/Skardyy/.dotfiles ~/.dotfiles
cd ~/.dotfiles

sudo dotbot -c windows.install.yaml
or ~
dotbot -c linux.install.yaml
```  
