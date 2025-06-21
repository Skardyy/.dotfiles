if status is-interactive
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PROFILE="$HOME/.config/fish/config.fish"
  export CC=clang
  export CXX=clang++
  set -x ANDROID_HOME /home/meron/Android/Sdk/
  set -x PATH $ANDROID_HOME/tools $PATH
  set -x PATH $ANDROID_HOME/platform-tools $PATH
  export FZF_DEFAULT_OPTS="
  --color=fg:#e5e5e5,hl:#95FB79
  --color=fg+:#ffffff,bg+:#1E1F24,hl+:#95FB79
  --color=info:#82AAFF,prompt:#82AAFF,pointer:#ffdb29
  --color=marker:#D2A6FF,spinner:#FFEE99,header:#2e3339
  --color=border:#1E1F24,label:#82AAFF,query:#FFFFFF
  --color=disabled:#2e3339,preview-fg:#FFFFFF
  --border=rounded
  --height=40%
  --layout=reverse
  --info=inline
  --margin=1
  --padding=1"

  alias v='nvim'
  alias o='mcat'
  function e
      set -l target "."
      if test (count $argv) -gt 0
          set target "$argv[1]"
      end

      set target (realpath "$target")
      hyprctl dispatch exec dolphin "$target"
  end
  alias scb='wl-copy'
  alias c="fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf --preview 'exa --tree --color=always {}' --bind tab:down | read -l dir; and cd \$dir; and commandline -f repaint"
  bind \co 'c'
end
