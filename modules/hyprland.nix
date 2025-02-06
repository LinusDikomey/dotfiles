{
  monitor = [
    "DP-4, 3840x2160@60, 0x0, 1"
    "HDMI-A-5, 1920x1080@60, 3840x1080, 1"
  ];

  # put workspace 1 on the main monitor
  workspace = "1, monitor:DP-4, default:true";

  exec-once = [
    "waybar"
    "bash ~/.config/eww/scripts/init"
    "nm-applet"
    "gammastep"
    "hypridle"
    "/usr/lib/polkit-kde-authentication-agent-1"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "dunst"
  ];

  # all for making hyprland work better with nvidia
  env = [
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm" # remove if firefox crashes
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "WLR_NO_HARDWARE_CURSORS,1"
  ];

  input = {
    kb_layout = "us";
    # kb_variant = colemak_dh_ortho
    kb_options = "compose:rwin";

    follow_mouse = 1;
    sensitivity = -0.75;
  };

  general = {
    gaps_in = 3;
    gaps_out = 5;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    #col.active_border = "rgba(b4befeee) rgba(b4befeee) 45deg";
    #col.inactive_border = "rgba(6c7086aa)";
    layout = "dwindle";

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;
  };

  decoration = {
    rounding = 0;

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
  };

  "$mod" = "SUPER";
  bind =
    [
      "$mod, Return, exec, ghostty"
      "$mod Shift, Return, exec, ghostty" # if ghostty doesn't work
      "bind = $mod SHIFT, Q, killactive,"
      "$mod Shift, Escape, exec, wlogout"

      "$mod, Q, exec, discord"
      "$mod, W, exec, firefox"
      "$mod, F, exec, nautilus"
      "$mod, P, exec, spotify"
      "$mod, B, exec, speedcrunch"

      "$mod SHIFT, S, exec, bash ~/dotfiles/scripts/screenshot"

      # media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -2%"
      ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +2%"
      ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

      "$mod, V, togglefloating"
      "$mod, Backspace, fullscreen"
      # fullscreen with super + backspace (also press shift to keep bar)
      "$mod SHIFT, Backspace, fullscreen, 1"
      "bindm = $mod, mouse:274, togglefloating"
      "$mod, Space, exec, wofi --theme launcher --modi drun,run,window,ssh,filebrowser --show drun"

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
}
