{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.desktop;
in {
  programs.niri = lib.mkIf (cfg.enable && builtins.elem "niri" cfg.desktops) {
    enable = true;
    settings = {
      outputs."DP-4" = {
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
        scale = 1.5;
      };
      outputs."HDMI-A-5" = {
        position = {
          x = 2560;
          y = 720;
        };
      };
      # outputs = builtins.mapAttrs (
      #   (name: m: {
      #     focus-at-startup = m.primary;
      #     position = m.offset;
      #     scale = m.scale;
      #   })
      #   cfg.monitors
      # );
      binds = {
        "Mod+M".action.focus-column-left = {};
        "Mod+N".action.focus-window-down = {};
        "Mod+E".action.focus-window-up = {};
        "Mod+I".action.focus-column-right = {};
        "Mod+Space".action.spawn = [
          "${pkgs.wofi}/bin/wofi"
          "--theme"
          "launcher"
          "--modi"
          "drun,run,window,ssh,filebrowser"
          "--show"
          "drun"
        ];
        "Mod+Q" = {
          action.close-window = {};
          repeat = false;
        };
        "Mod+Return".action.spawn = "${pkgs.ghostty}/bin/ghostty";
        "Mod+Shift+Escape".action.spawn = "${pkgs.wlogout}/bin/wlogout";
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
      };
    };
  };
}
