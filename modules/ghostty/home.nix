{ config, mod, ... }: {
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${mod}/ghostty/config";

  xdg.configFile."ghostty/cursor_warp.glsl".source =
    config.lib.file.mkOutOfStoreSymlink "${mod}/ghostty/cursor_warp.glsl";
}
