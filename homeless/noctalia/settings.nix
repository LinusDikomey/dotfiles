{
  lib,
  config,
  pkgs,
  ...
}: let
  monitors = config.dotfiles.graphical.monitors or {};
  op1wBattery = pkgs.writeScriptBin "op1w-battery" ''
    #!${pkgs.runtimeShell}
    export PATH=${lib.makeBinPath [pkgs.libnotify]}:$PATH
    exec ${pkgs.python3}/bin/python3 ${toString ./op1w-battery.py}
  '';
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
      right =
        [
          {id = "Tray";}
          {id = "NotificationHistory";}
        ]
        ++ (lib.optional (config.dotfiles.graphical.op1w-mouse or false)
          {
            id = "CustomButton";
            icon = "battery";
            iconPosition = "left";
            showIcon = true;
            textCommand = "${op1wBattery}/bin/op1w-battery";
            parseJson = true;
            textIntervalMs = 60000;
            maxTextLength = {
              horizontal = 4;
              vertical = 4;
            };
            hideMode = "alwaysExpanded";
            leftClickUpdateText = true;
            showExecTooltip = false;
            showTextTooltip = true;
            generalTooltipText = "OP1w 4K";
          })
        ++ [
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
