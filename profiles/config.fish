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
  --color=fg:#d0d0d2,hl:#92c468
  --color=fg+:#ffffff,bg+:#1E1F24,hl+:#92c468
  --color=info:#94A3C5,prompt:#f7e254,pointer:#ffdb29
  --color=marker:#FF875F,spinner:#94A3C5,header:#24292e
  --color=border:#1E1F24,label:#8e8e90,query:#e8e8ea
  --color=disabled:#24292e,preview-fg:#e8e8ea
  --border=rounded
  --height=40%
  --layout=reverse
  --info=inline
  --margin=1
  --padding=1"

  alias v='nvim'
  alias e='hyprctl dispatch exec dolphin'
  alias scb='wl-copy'
  alias c="fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf --preview 'exa --tree --color=always {}' --bind tab:down | read -l dir; and cd \$dir; and commandline -f repaint"
  bind \co 'c'
end
