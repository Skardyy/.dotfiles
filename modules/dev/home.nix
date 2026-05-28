{ pkgs, ... }: {
  home.packages = with pkgs; [
    # languages
    python3
    uv
    nodejs
    go
    rustup
    zig

    # compilers / build tools
    cmake
    ninja
    gnumake
    clang-tools

    # cli utils
    curl
    ripgrep
    fd
    eza
    fzf
    github-cli
    difftastic
    tree-sitter
    zip
    unzip
    less

    # virt
    devpod

    # media
    ffmpeg
    mpv
  ] ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
    gcc
  ];
}
