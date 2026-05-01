{ pkgs, ... }: {
  home.packages = with pkgs; [
    # languages
    python3
    uv
    nodejs
    go
    rustup

    # compilers / build tools
    gcc
    cmake
    ninja
    gnumake

    # cli utils
    curl
    ripgrep
    fd
    eza
    fzf
    github-cli
    difftastic
    tree-sitter
    wl-clipboard
    zip
    unzip
    less
    brave
  ];
}
