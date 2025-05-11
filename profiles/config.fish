if status is-interactive
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.cargo/bin:$PATH"
  export PROFILE="$HOME/.config/fish/config.fish"
  export CC=clang
  export CXX=clang++
  set -x ANDROID_HOME /home/meron/Android/Sdk/
  set -x PATH $ANDROID_HOME/tools $PATH
  set -x PATH $ANDROID_HOME/platform-tools $PATH
  set -gx FZF_DEFAULT_OPTS "
  --color=bg+:#1e2029,bg:#15161B,spinner:#FFEE99,hl:#FFEE99 \
  --color=fg:#A6ACCD,header:#FF7733,info:#D2A6FF,pointer:#FFEE99 \
  --color=marker:#95FB79,fg+:#FFFFFF,prompt:#82AAFF,hl+:#95FB79 \
  --color=border:#25282E \
  --height 40% --border=rounded --reverse --margin=1 --padding=1"

  alias v='nvim'
  alias scb='wl-copy'
  alias c="fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf --preview 'exa --tree --color=always {}' | read -l dir; and cd \$dir; and commandline -f repaint"
end
