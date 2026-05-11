{
  lib,
  config,
  ...
}: let
  monitors = config.dotfiles.graphical.monitors or {};
in {
  bar = {
    density = "comfortable";
    ${
      if monitors != {}
      then "monitors"
      else null
    } = [
      (
        lib.lists.findFirst
        (name: monitors.${name}.primary or false)
        null
        (builtins.attrNames monitors)
      )
    ];
    colorSchemes.predefinedScheme = "Catppuccin";
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
  dock.enabled = false;
  location.name = config.dotfiles.city or null;
  audio.volumeStep = 2;
  nightLight = {
    enabled = true;
    manualSunrise = "5:30";
    manualSunset = "22:30";
    dayTemp = "6500";
    nightTemp = "3600";
  };
  wallpaper = {
    directory = ../../wallpapers;
    overviewEnabled = true;
  };
}
