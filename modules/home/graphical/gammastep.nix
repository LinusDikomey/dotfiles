{
  config,
  lib,
  pkgs,
  ...
}: {
  config.services.gammastep = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;

    dawnTime = "5:00-5:30";
    duskTime = "23:00-23:30";
    temperature.day = 6500;
    temperature.night = 3600;
    tray = true;
  };
}
