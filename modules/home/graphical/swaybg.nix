{
  lib,
  config,
  dotfiles,
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
      ExecStart = "${pkgs.swaybg}/bin/swaybg --image ${dotfiles.wallpaper}";
      Restart = "always";
      RestartSec = 5;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
