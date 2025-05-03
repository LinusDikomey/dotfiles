{
  config,
  lib,
  ...
}: {
  config.services.gammastep = lib.mkIf config.dotfiles.desktop.enable {
    enable = true;

    dawnTime = "5:00-5:30";
    duskTime = "23:00-23:30";
    temperature.day = 6500;
    temperature.night = 3600;
    tray = true;
  };
}
