{
  lib,
  config,
  dotfiles,
  pkgs,
  ...
}: {
  programs.swaylock = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      clock = true;
      fade-in = 0.5;
      grace = 10;
      image = "${dotfiles.wallpaper}";
      effect-blur = "7x5";
      font = config.dotfiles.theme.font.name;
      indicator-idle-visible = true;
      show-failed-attempts = true;
      timestr = "%H:%M";
      datestr = "%A, %d.%m.%Y";
    };
  };
}
