{
  lib,
  config,
  dotfiles,
  pkgs,
  ...
}: {
  config.services.hyprpaper = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    settings = {
      preload = "${dotfiles.wallpaper}";
      wallpaper = ",${dotfiles.wallpaper}";
      splash = false;
      ipc = "off";
    };
  };
}
