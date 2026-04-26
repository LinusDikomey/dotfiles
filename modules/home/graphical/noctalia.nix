{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.graphical;
in {
  programs.noctalia-shell = {
    enable = config.dotfiles.graphical.enable;
    settings = {
      bar = {
        density = "comfortable";
        monitors = [
          (
            lib.lists.findFirst
            (name: cfg.monitors.${name}.primary or false)
            null
            (builtins.attrNames cfg.monitors)
          )
        ];
        colorSchemes.predefinedScheme = "Catppuccin";
        dock.enabled = false;
        widgets = {
          left = [
            {id = "Launcher";}
            {id = "Clock";}
            {id = "SystemMonitor";}
            {
              id = "ActiveWindow";
              maxWidth = 400;
            }
            {
              id = "MediaMini";
              maxWidth = 250;
            }
          ];
          center = [
            {
              id = "Workspace";
              maxWidth = 250;
              followFocusedScreen = true;
              showLabelsOnlyWhenOccupied = false;
            }
          ];
          right = [
            {id = "Tray";}
            {id = "NotificationHistory";}
            {id = "Battery";}
            {id = "Volume";}
            {id = "Brightness";}
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };
      location.name = cfg.city;
      audio.volumeStep = 2;
      nightLight = {
        enabled = true;
        manualSunrise = "5:30";
        manualSunset = "22:30";
        dayTemp = "6500";
        nightTemp = "3600";
      };
      wallpaper = {
        directory = ../../../wallpapers;
        overviewEnabled = true;
      };
    };
  };
}
