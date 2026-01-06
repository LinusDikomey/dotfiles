{
  lib,
  config,
  dotfiles,
  pkgs,
  ...
}: {
  config.services.hyprpaper = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    settings.wallpaper = {
      monitor = "";
      path = "${dotfiles.wallpaper}";
      fit_mode = "cover";
    };
  };
}
