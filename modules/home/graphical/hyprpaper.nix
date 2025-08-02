{
  lib,
  config,
  dotfiles,
  ...
}: {
  config.services.hyprpaper = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    settings = {
      preload = "${dotfiles.wallpaper}";
      wallpaper = ",${dotfiles.wallpaper}";
      splash = false;
      ipc = "off";
    };
  };
}
