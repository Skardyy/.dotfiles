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

  function what
    set_color yellow
    echo -n "Time: "
    set_color green
    date "+%d/%m/%Y %H:%M"

    set_color yellow
    echo -n "WIFI: "
    set_color green
    nmcli device show wlan0 | rg -i general.connection | rg --color never --pcre2 -i '\s*general.connection:\s*(.*)' -r '$1'

    set_color yellow
    echo -n "Battery: "
    set_color green
    acpi -b | awk '{print $4}'
    set_color normal
  end
end
