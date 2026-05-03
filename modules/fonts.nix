{ pkgs, user, ... }:
let
  commitMono = pkgs.stdenvNoCC.mkDerivation {
    pname = "commit-mono-skardyy";
    version = "1.0.0";
    src = pkgs.fetchzip {
      url = "https://github.com/Skardyy/fonts/releases/download/1.0.0/CommitMono.tar.gz";
      hash = "sha256-QYI5CFIZCEWCv95ytjJOvRnEa8Kghv10PfSbSSOmKUw=";
      stripRoot = false;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find . -type f \( -name "*.ttf" -o -name "*.otf" \) \
        -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };

  zedMono = pkgs.stdenvNoCC.mkDerivation {
    pname = "zed-mono-skardyy";
    version = "1.0.0";
    src = pkgs.fetchzip {
      url = "https://github.com/Skardyy/fonts/releases/download/1.0.0/ZedMono.tar.gz";
      hash = "sha256-dtMy9VLyY+inub1caaxk72zSnLUYUFKDevyRRjXx51M=";
      stripRoot = false;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find . -type f \( -name "*.ttf" -o -name "*.otf" \) \
        -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };

  fontPkgs = [
    commitMono
    zedMono
  ] ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) (with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    dejavu_fonts
    liberation_ttf
  ]);
in
if pkgs.stdenv.isDarwin then {
  home-manager.users.${user}.home.packages = fontPkgs;
} else {
  fonts.packages = fontPkgs;
}
