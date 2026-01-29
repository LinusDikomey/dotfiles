{
  pkgs,
  localPkgs,
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.graphical;
in {
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.desktops) {
    home.packages = with pkgs; [hyprshot];
    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config = {
        common.default = ["hyprland"];
        hyprland.default = ["hyprland"];
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      # use packages from NixOS module
      package = null;
      # portalPackage = pkgs.xdg-desktop-portal-gtk;
      settings = {
        monitor =
          (
            map
            (
              name: let
                m = cfg.monitors.${name};
                s = toString;
                framerate =
                  if builtins.hasAttr "framerate" m
                  then "@${s m.framerate}"
                  else "";
                nameOrDesc =
                  if builtins.hasAttr "desc" m
                  then "desc:${m.desc}"
                  else name;
              in "${nameOrDesc}, ${s m.resolution.x}x${s m.resolution.y}${framerate}, ${s m.offset.x}x${s m.offset.y}, ${s m.scale}, bitdepth, 8"
            )
            (builtins.attrNames cfg.monitors)
          )
          ++ [
            ", preferred, auto, 1" # fallback for other monitors
          ];

        # put workspace 1 on the main monitor
        workspace = let
          monitors = builtins.attrNames cfg.monitors;
          isPrimary = name: cfg.monitors.${name}.primary or false;
          primary = lib.lists.findFirst isPrimary null monitors;
          secondary = lib.lists.findFirst (name: !(isPrimary name)) null monitors;
        in
          [
            "1, monitor:desc:${cfg.monitors.${primary}.desc}, default:true"
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"
          ]
          ++ lib.optionals (secondary != null) [
            "3, monitor:desc:${cfg.monitors.${secondary}.desc}, default:true"
            "4, monitor:desc:${cfg.monitors.${secondary}.desc}"
          ];

        windowrule = [
          # smart gaps
          "border_size 0, match:float 0, match:workspace w[tv1]"
          "rounding 0, match:float 0, match:workspace w[tv1]"
          "border_size 0, match:float 0, match:workspace f[1]"
          "rounding 0, match:float 0, match:workspace f[1]"

          # enable tearing for some games
          "match:class Minecraft, immediate on"
          "match:class waywall, immediate on"
          "match:class discord xwayland:0 forceinput"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ];

        env = lib.mkIf cfg.nvidia [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm" # remove if firefox crashes
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
          "NIXOS_OZONE_WL,1"
        ];

        xwayland.force_zero_scaling = true;

        input = {
          kb_layout = "us";
          # kb_variant = colemak_dh_ortho
          kb_options = "compose:rwin";

          follow_mouse = 1;
          sensitivity = -0.75;
          accel_profile = "flat";
        };

        general = {
          gaps_in = 2;
          gaps_out = 1;
          border_size = 2;
          "col.active_border" = "rgba(9bd7f2ee) rgba(9bd7f2ee)";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = true;
        };

        decoration = {
          rounding = 4;

          blur = {
            enabled = true;
            size = 24;
            passes = 1;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;

            color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = "yes";

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };

        misc = {
          disable_hyprland_logo = true;
          swallow_regex = "^(ghostty)$";
          enable_anr_dialog = false; # false positives on some applications made this very annoying for me
        };

        "$mod" = "SUPER";
        bind = let
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
          [
            "$mod, Return, exec, ghostty"
            "$mod Shift, Return, exec, kitty" # if ghostty doesn't work
            "bind = $mod SHIFT, Q, killactive,"
            "$mod Shift, Escape, exec, ${pkgs.wlogout}/bin/wlogout"

            "$mod, Q, exec, [workspace 3] discord"
            "$mod, W, exec, firefox"
            "$mod, F, exec, nautilus"
            "$mod, P, exec, [workspace 4] spotify"

            "$mod SHIFT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --freeze --clipboard-only"
            "$mod, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
            "$mod CONTROL, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m window --clipboard-only"
            "$mod CONTROL SHIFT, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m window --freeze --clipboard-only"

            # media
            ", XF86AudioPlay, exec, ${playerctl} play-pause"
            ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -2%"
            ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +2%"
            ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"

            "$mod, V, togglefloating"
            "$mod, Backspace, fullscreen"
            # fullscreen with super + backspace (also press shift to keep bar)
            "$mod SHIFT, Backspace, fullscreen, 1"
            "bindm = $mod, mouse:274, togglefloating"
            "$mod, Space, exec, ${pkgs.wofi}/bin/wofi --theme launcher --modi drun,run,window,ssh,filebrowser --show drun"

            "$mod, L, pseudo,"
            "$mod, T, togglesplit,"

            # Move focus with mainMod + arrow keys
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            # also move with mainMod + mnei
            "$mod, M, movefocus, l"
            "$mod, N, movefocus, d"
            "$mod, E, movefocus, u"
            "$mod, I, movefocus, r"

            # move windows with super+shift + mnei
            "$mod SHIFT, M, movewindow, l"
            "$mod SHIFT, N, movewindow, d"
            "$mod SHIFT, E, movewindow, u"
            "$mod SHIFT, I, movewindow, r"

            # Scroll through existing workspaces with mainMod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"

            # toggle swaync pannel
            "$mod, X, exec, swaync-client --toggle-panel"
          ]
          ++ (
            builtins.concatLists (builtins.genList (i: let
                key =
                  if i == 9
                  then "0"
                  else toString (i + 1);
                ws = toString (i + 1);
              in [
                "$mod, ${key}, workspace, ${ws}"
                "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
              ])
              10)
          )
          # global shortcuts
          ++ [
            # discord mute / deafen
            "$mod, y, sendshortcut, CONTROL SHIFT, M, class:^(discord)$"
            "$mod, Semicolon, sendshortcut, CONTROL SHIFT, D, class:^(discord)$"
          ];
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
