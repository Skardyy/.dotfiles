if status is-interactive
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PATH="/opt/homebrew:$PATH"
  export PATH="/opt/homebrew/bin:$PATH"
  export PROFILE="$HOME/.config/fish/config.fish"
  export CC=clang
  export CXX=clang++
  set -x ANDROID_HOME /home/meron/Android/Sdk/
  # set -x ANDROID_HOME ~/Library/Android/sdk
  set -x PATH $ANDROID_HOME/tools $PATH
  set -x PATH $ANDROID_HOME/platform-tools $PATH

  alias v='nvim'
  alias o='mcat'
  alias pine="PROTONPATH=GE-Proton umu-run"
  alias ls="eza"
  function e
      set -l target "."
      if test (count $argv) -gt 0
          set target "$argv[1]"
      end

      set target (realpath "$target")
      hyprctl dispatch exec nemo "$target"
  end
  alias scb='wl-copy'
end
