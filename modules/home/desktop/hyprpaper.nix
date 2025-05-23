{
  lib,
  config,
  dotfiles,
  ...
}: {
  config.services.hyprpaper = lib.mkIf config.dotfiles.desktop.enable {
    enable = true;
    settings = {
      preload = "${dotfiles.wallpaper}";
      wallpaper = ",${dotfiles.wallpaper}";
      splash = false;
      ipc = "off";
    };
  };
}
