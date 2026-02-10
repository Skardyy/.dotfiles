<div align=center>
  
  # My dotfiles

My dotfiles for Arch / MacOS

| Desktop                                                                                   | Neovim                                                                                    |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| ![image](https://github.com/user-attachments/assets/306bbc49-f3ca-40fe-992c-55282527bffa) | ![image](https://github.com/user-attachments/assets/60e00134-8fba-49bb-98ac-27f8b020c381) |

</div>

> [!Note]
>
> I install the dotfiles using [dotbot](https://github.com/anishathalye/dotbot)  
> but configuring it differently or using a different dotfiles manager should be rather easy -  
> the [macos installer](./macos.install.yaml) and [linux installer](./linux.install.yaml) tell you everything on what should be where

> [!Tip]
>
> the dotfiles uses [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) for arch

# Install

```sh
pip install dotbot
git clone https://github.com/Skardyy/.dotfiles ~/.dotfiles
cd ~/.dotfiles

dotbot -c macos.install.yaml
or ~
dotbot -c linux.install.yaml
```
