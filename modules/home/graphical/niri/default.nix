{
  lib,
  config,
  pkgs,
  localPkgs,
  ...
}: let
  cfg = config.dotfiles.graphical;
  keys = {
    # Colemak DH home row keys
    "M" = "left";
    "N" = "down";
    "E" = "up";
    "I" = "right";
    # arrow keys
    "Left" = "left";
    "Down" = "down";
    "Up" = "up";
    "Right" = "right";
  };
in {
  programs.niri = lib.mkIf (cfg.enable && builtins.elem "niri" cfg.desktops) {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      environment."NIXOS_OZONE_WL" = "1";
      hotkey-overlay.skip-at-startup = true;
      # outputs."DP-3" = {
      #   focus-at-startup = true;
      #   position = {
      #     x = 0;
      #     y = 0;
      #   };
      #   scale = 1.5;
      # };
      # outputs."HDMI-A-5" = {
      #   position = {
      #     x = 2560;
      #     y = 720;
      #   };
      # };
      outputs =
        builtins.mapAttrs
        (name: m: {
          focus-at-startup = m.primary or false;
          position = m.offset;
          mode = {
            width = m.resolution.x;
            height = m.resolution.y;
          };
          scale = m.scale;
        })
        cfg.monitors;
      prefer-no-csd = true;
      clipboard.disable-primary = true;
      input = {
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "95%";
        };
        keyboard = {
          repeat-delay = 350;
          xkb.options = "compose:rwin";
        };
        mouse = {
          accel-profile = "flat";
          accel-speed = -0.35;
        };
      };
      cursor.hide-when-typing = true;
      gestures.hot-corners.enable = false;
      layout = {
        focus-ring.width = 2.5;
        gaps = 6;
        struts = {
          left = 2;
          right = 2;
          top = 2;
          bottom = 2;
        };
        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
        ];
      };
      binds = let
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
      in
        {
          "Mod+Space".action.spawn = [
            "${pkgs.wofi}/bin/wofi"
            "--theme"
            "launcher"
            "--modi"
            "drun,run,window,ssh,filebrowser"
            "--show"
            "drun"
          ];

          "Mod+Shift+Q" = {
            action.close-window = {};
            repeat = false;
          };

          "Mod+Return".action.spawn = "${pkgs.ghostty}/bin/ghostty";
          "Mod+Shift+Escape".action.spawn = "${pkgs.wlogout}/bin/wlogout";
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};

          "Mod+O" = {
            action.toggle-overview = {};
            repeat = false;
          };
          "Mod+WheelScrollDown" = {
            action.focus-workspace-down = {};
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action.focus-workspace-up = {};
            cooldown-ms = 150;
          };
          "Mod+D".action.focus-workspace-down = {};
          "Mod+U".action.focus-workspace-up = {};

          "Mod+Comma".action.consume-or-expel-window-left = {};
          "Mod+Period".action.consume-or-expel-window-right = {};
          "Mod+R".action.switch-preset-column-width = {};
          "Mod+K".action.maximize-column = {};
          "Mod+H".action.expand-column-to-available-width = {};
          "Mod+C".action.center-column = {};
          "Mod+Shift+C".action.center-visible-columns = {};
          "Mod+Backspace".action.fullscreen-window = {};
          "Mod+T".action.toggle-column-tabbed-display = {};
          "Mod+V".action.toggle-window-floating = {};

          # programs
          "Mod+W".action.spawn = "${localPkgs.helium}/bin/helium";
          "Mod+F".action.spawn = "${pkgs.nautilus}/bin/nautilus";

          # screenshots/screencasts
          "Mod+Shift+S".action.screenshot = {};
          "Mod+S".action.screenshot-window = {};
          "Mod+Ctrl+S".action.screenshot-screen = {};
          "Mod+Y".action.set-dynamic-cast-monitor = {};
          "Mod+Shift+Y".action.set-dynamic-cast-window = {};
          "Mod+Ctrl+Y".action.clear-dynamic-cast-target = {};

          # media buttons
          "XF86AudioPlay".action.spawn = [playerctl "play-pause"];
          "XF86AudioLowerVolume".action.spawn = [pactl "set-sink-volume" "@DEFAULT_SINK@" "-2%"];
          "XF86AudioRaiseVolume".action.spawn = [pactl "set-sink-volume" "@DEFAULT_SINK@" "+2%"];
          "XF86AudioMute".action.spawn = [pactl "set-sink-mute" "@DEFAULT_SINK@" "toggle"];
        }
        // builtins.listToAttrs (lib.lists.flatten (builtins.genList (i: [
            {
              name = "Mod+${builtins.toString i}";
              value.action.focus-workspace = i;
            }
            {
              name = "Mod+Shift+${builtins.toString i}";
              value.action.move-column-to-workspace = i;
            }
          ])
          9))
        // (lib.foldl' lib.recursiveUpdate {} (builtins.map (
            key: let
              dir = keys.${key};
              cw =
                if builtins.elem dir ["left" "right"]
                then "column"
                else "window";
            in {
              "Mod+${key}".action."focus-${cw}-${dir}" = {};
              "Mod+Shift+${key}".action."move-${cw}-${dir}" = {};
              "Mod+Shift+Ctrl+${key}".action."move-column-to-monitor-${dir}" = {};
              "Mod+Ctrl+${key}".action."focus-monitor-${dir}" = {};
            }
          )
          (builtins.attrNames keys)));
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
    };
  };
}
