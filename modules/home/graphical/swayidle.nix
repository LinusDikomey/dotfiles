{
  lib,
  config,
  pkgs,
  ...
}: {
  config.services.swayidle = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    timeouts = let
      minutes = n: 60 * n;
    in [
      {
        timeout = minutes 10;
        command = "''${pkgs.swaylock}/bin/swaylock --daemonize";
      }
      {
        timeout = minutes 15;
        command = "niri msg action power-off-monitors";
      }
      {
        timeout = minutes 30;
        command = "systemctl suspend";
      }
    ];
  };
}
