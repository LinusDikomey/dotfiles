{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.desktop;
in {
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.desktops) {
    xdg.portal.configPackages = [pkgs.xdg-desktop-portal-hyprland];
    wayland.windowManager.hyprland = {
      enable = true;
      # use packages from NixOS module
      package = null;
      # portalPackage = pkgs.xdg-desktop-portal-gtk;
      settings = {
        monitor =
          (builtins.map (m: "${m.output}, ${m.resolution}@${builtins.toString m.framerate}, ${m.offset}, ${builtins.toString m.scale}") cfg.monitors)
          ++ [
            ", preferred, auto, 1" # fallback for other monitors
          ];

        # put workspace 1 on the main monitor
        workspace = let
          primary = (lib.lists.findFirst (m: m.primary) null cfg.monitors).output;
        in [
          "1, monitor:${primary}, default:true"
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
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
          sensitivity = -0.45;
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
          allow_tearing = false;
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
          screenshot = pkgs.writeShellScript "screenshot" ''
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
          '';
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
          [
            "$mod, Return, exec, ghostty"
            "$mod Shift, Return, exec, kitty" # if ghostty doesn't work
            "bind = $mod SHIFT, Q, killactive,"
            "$mod Shift, Escape, exec, ${pkgs.wlogout}/bin/wlogout"

            "$mod, Q, exec, discord"
            "$mod, W, exec, firefox"
            "$mod, F, exec, nautilus"
            "$mod, P, exec, spotify"

            "$mod SHIFT, S, exec, ${screenshot}"

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
          );
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
