if status is-interactive
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PROFILE="$HOME/.config/fish/config.fish"
  set -x ANDROID_HOME /home/meron/Android/Sdk/
  set -x PATH $ANDROID_HOME/tools $PATH
  set -x PATH $ANDROID_HOME/platform-tools $PATH

  #alias rs='i3-msg exec'
  #alias vd='i3-msg exec "vivaldi"'
  alias v='nvim'

  nvm use latest

  # Requires: brightnessctl, acpi, ripgrep
  function what
    set_color yellow
    echo -n "Time:        "
    set_color green
    date "+%d/%m/%Y %H:%M"

    set_color yellow
    echo -n "WIFI:        "
    set_color green
    nmcli device show wlan0 | rg -i general.connection | rg --color never --pcre2 -i '\s*general.connection:\s*(.*)' -r '$1'

    set_color yellow
    echo -n "Battery:     "
    set_color green
    acpi -b | awk '{print $4}' | rg '[^,]+' -o --color never

    set_color yellow
    echo -n "Brightness:  "
    set brightness_percent (math "round(($(brightnessctl get) / $(brightnessctl max)) * 100)")
    set_color green
    echo $brightness_percent%
    set_color normal
  end
end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
