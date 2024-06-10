if status is-interactive
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PROFILE="$HOME/.config/fish/config.fish"
  set -x ANDROID_HOME /home/meron/Android/Sdk/
  set -x PATH $ANDROID_HOME/tools $PATH
  set -x PATH $ANDROID_HOME/platform-tools $PATH

  alias rs='i3-msg exec'
  alias vd='i3-msg exec "vivaldi"'
  alias v='nvim'
  xrdb -merge ~/.Xresources
end
