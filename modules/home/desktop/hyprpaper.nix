{
  lib,
  config,
  ...
}: {
  config.services.hyprpaper = lib.mkIf config.dotfiles.desktop.enable {
    enable = true;
    settings = {
      preload = "~/wallpaper.png";
      wallpaper = ",~/wallpaper.png";
      splash = false;
      ipc = "off";
    };
  };
}
