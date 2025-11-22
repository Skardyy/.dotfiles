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
  --color=fg:#e5e5e5,hl:#a2d93d
  --color=fg+:#ffffff,bg+:#1E1F24,hl+:#a2d93d
  --color=info:#60bfbf,prompt:#60bfbf,pointer:#ffdb29
  --color=marker:#e67399,spinner:#facc75,header:#2e3339
  --color=border:#1E1F24,label:#60bfbf,query:#FFFFFF
  --color=disabled:#2e3339,preview-fg:#FFFFFF
  --border=rounded
  --height=60%
  --layout=reverse
  --info=inline
  --margin=1
  --padding=1"

  alias v='nvim'
  alias o='mcat'
  alias pine="PROTONPATH=GE-Proton umu-run"
  function e
      set -l target "."
      if test (count $argv) -gt 0
          set target "$argv[1]"
      end

      set target (realpath "$target")
      hyprctl dispatch exec nemo "$target"
  end
  alias scb='wl-copy'
  alias c="fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf --preview 'exa --tree --color=always {}' --bind tab:down | read -l dir; and cd \$dir; and commandline -f repaint"
  bind \co 'c'
end
