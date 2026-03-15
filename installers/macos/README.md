# Autoraise

```sh
brew tap dimentium/autoraise
brew install autoraise --with-dexperimental_focus_first
echo delay=0 > ~/.AutoRaise
brew services start autoraise
```

# Kanata

```bash
brew install kanata
brew install --cask karabiner-elements
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
# Settings -> General -> Login items and extension -> Driver extension -> enable
# At login items, enable both then normal and privileged daemon of Karabiner
# add /opt/homebrew/bin/kanata to the input monitoring
```
