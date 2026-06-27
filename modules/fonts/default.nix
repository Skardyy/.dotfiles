{ lib, pkgs, user, ... }:
let
  commitMono = pkgs.stdenvNoCC.mkDerivation {
    pname = "commit-mono-skardyy";
    version = "0.1.0";
    src = pkgs.fetchzip {
      url = "https://github.com/Skardyy/fonts/releases/download/v0.1.0/CommitMonoMn.tar.gz";
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

  caskaydiaCove = pkgs.stdenvNoCC.mkDerivation {
    pname = "caskaydia-cove-mn-skardyy";
    version = "0.1.0";
    src = pkgs.fetchzip {
      url = "https://github.com/Skardyy/fonts/releases/download/v0.1.0/CaskaydiaCoveMn.tar.gz";
      hash = "sha256-S5q8IaE5BrwGwpI/8PIws72QqwHEzYGQYxjkmhycAPI=";
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
    version = "0.1.0";
    src = pkgs.fetchzip {
      url = "https://github.com/Skardyy/fonts/releases/download/v0.1.0/ZedMonoMn.tar.gz";
      hash = "sha256-oTx+qk3O3ioA6g9aLLaA/YypXkmp79j146VXRDcD3p0=";
      stripRoot = false;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      find . -type f \( -name "*.ttf" -o -name "*.otf" \) \
        -exec cp {} $out/share/fonts/truetype/ \;
    '';
  };

  isDarwin = pkgs.stdenv.isDarwin;

  fontPkgs = [
    commitMono
    caskaydiaCove
    zedMono
  ] ++ lib.optionals (!isDarwin) (with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    dejavu_fonts
    liberation_ttf
  ]);
in
{
  fonts = lib.mkIf (!isDarwin) {
    packages = fontPkgs;
  };

  home-manager.users.${user} = lib.mkIf isDarwin {
    home.packages = fontPkgs;
  };
}
