> \[!Note]
> For now the prerequisites are just instruction of installation
> Or may lack all the instruction for installing
> Later I'll create scripts for Bash/Pwsh for installing `everything` quicker

# Table of Contents
* [Ohmyposh](#ohmyposh)
* [Fonts](#fonts)
* [Alacritty](#alacritty)
* [Wezterm](#wezterm)
* [Taskbar Tools](#install-taskbar-tools)
* [fzf and bat](#install-fzf-and-bat)
* [altDrag](#install-altdrag)

## Ohmyposh  
```pwsh
winget install JanDeDobbeleer.OhMyPosh -s winget

oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\m.min.omp.json' | Invoke-Expression" > $PROFILE

or for nu ~

oh-my-posh init nu --config '~\AppData\Local\Programs\oh-my-posh\themes\m.min.omp.json'
source ~/.oh-my-posh.nu
```

## Fonts  
* goto [nerd repo](https://github.com/ryanoasis/nerd-fonts/releases/latest)
* install the ZedMono font (extended version)


## Alacritty  
* goto [alarcitty latest release](https://github.com/alacritty/alacritty/releases/latest)


## Wezterm  
* goto [wezterm latest release](https://github.com/wez/wezterm/releases/latest)


## install taskbar tools
* install ttb from [microsoft store](https://apps.microsoft.com/detail/9pf4kz2vn4w9?hl=en-US&gl=US)
* install taskbarx zip from [github](https://github.com/ChrisAnd1998/TaskbarX/releases/latest)
* put the taskbarx app inside the startup apps `shell:startup`


## install fzf and bat
```pwsh
winget install fzf
winget install sharkdp.bat
```


## install altDrag
* goto [AltDrag website](https://stefansundin.github.io/altdrag/)
