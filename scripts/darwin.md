# Darwin (macOS) setup

```sh
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
sudo nix run nix-darwin -- switch --flake ~/.dotfiles#darwin-meron
```
