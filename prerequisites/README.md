> \[!Note]
> Some things aren't supported by winutil  
> so they will need to be configured manually  

# Winutil
* open a terminal on admin
* run `irm "https://christitus.com/win" | iex`
* import the [winutil config](https://github.com/Skardyy/.dotfiles/blob/main/prerequisites/winutil.json)

# Sam
* Shell-alias-maker is a tool i build for quickly opening apps from the terminal
* start by doing
```pwsh
git clone https://github.com/Skardyy/Shell-Alias-Maker sam
cd sam
go build
./sam.exe
cp ./sam.exe ~/.sam/dst
```
* finish by adding ~/.sam/dst into your path env
* and now you can add shortcuts by doing `sam add -c -n 'shortcut name' -t 'full path'`


# Seprate configs
* [Fonts](#fonts)
* [Taskbar Tools](#install-taskbar-tools)
* [altDrag](#install-altdrag)
* [cursor](#cursor)
* [fish](#install-fish)

### Fonts  
* goto [nerd repo](https://github.com/ryanoasis/nerd-fonts/releases/latest)
* install the ZedMono font (extended version)  

### install taskbar tools
* mainly for windows 10
* install ttb from [microsoft store](https://apps.microsoft.com/detail/9pf4kz2vn4w9?hl=en-US&gl=US)
* install taskbarx zip from [github](https://github.com/ChrisAnd1998/TaskbarX/releases/latest)
* put the taskbarx app inside the startup apps `shell:startup`

### install altDrag
* goto [AltDrag website](https://stefansundin.github.io/altdrag/)

## Cursor
* goto [jepri w11cc](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)

### install fish
```bash
sudo pacman -S fish
chsh -s /usr/bin/fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install ilancosman/tide
```
