**First**

```
xbps-install -Su
```

**Packages**

- niri
- dotbot
- neovim
- rustup
- ghostty
- kanata
- fish-shell
- base-devel
- clang
- llvm
- curl
- eza
- mesa-dri
- quickshell
- tree-sitter-cli (cargo)

**elogind**

```
xbps-install elogind
ln -s /etc/sv/elogind /var/service/
ln -s /etc/sv/dbus /var/service/
```

**seatd**

```
xbps-install seatd
ln -s /etc/sv/seatd /var/service/
usermod -aG _seatd meron
```

**Nvidia**

```
xbps-install void-repo-nonfree
xbps-install -S
xbps-install nvidia linux6.12-headers
```

Add to `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4 nvidia_drm.modeset=1"
```

Create `/etc/dracut.conf.d/nvidia.conf`:

```
add_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "
```

Then:

```
grub-mkconfig -o /boot/grub/grub.cfg
dracut --force
reboot
```

**DE (DankMaterialShell)**

```
curl -OL https://github.com/AvengeMedia/DankMaterialShell/releases/latest/download/dms-full-amd64.tar.gz
tar -xzf dms-full-amd64.tar.gz
cd dms-full-amd64
mkdir -p ~/.config/quickshell
cp -r dms ~/.config/quickshell
sudo install -m 755 bin/dms /usr/local/bin/dms
sudo install -m 644 completion/completion.fish /usr/share/fish/vendor_completions.d/dms.fish
```

**Config**

```
chsh -s /bin/fish
```
