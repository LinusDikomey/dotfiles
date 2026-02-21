{
  lib,
  config,
  pkgs,
  ...
}: {
  config.systemd.user.services.swaybg = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    Unit = {
      Description = "swaybg wallpaper";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg --image ${config.dotfiles.theme.wallpaper}";
      Restart = "always";
      RestartSec = 5;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
