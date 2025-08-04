{
  lib,
  config,
  pkgs,
  ...
}: {
  config.services.hypridle = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
      };

      # Screenlock
      listener = [
        {
          timeout = 600;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 720;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 7200; # has some issues with Nvidia Graphics on wayland so not enabling it too quickly
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
