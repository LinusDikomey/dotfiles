{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.wlogout = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = pkgs.writeShellScript "exit-desktop" ''
          if [ -n "''${NIRI_SOCKET}" ]; then
            niri msg action quit
          elif [ -n "''${HYPRLAND_INSTANCE_SIGNATURE}" ]; then
            hyprctl dispatch exit
          else
            echo "error: no desktop detected"
          fi
        '';
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "windows";
        action = "systemctl reboot --boot-loader-entry=auto-windows";
        text = "Boot to Windows";
        keybind = "w";
      }
    ];
    style =
      (builtins.readFile ./style.css)
      + lib.strings.concatStrings (builtins.map (
        x: let
          url = "url(\"${./icons}/${x}.png\")";
        in ''
          #${x} {
            background-image: image(${url}, ${url});
          }
        ''
      ) ["lock" "logout" "suspend" "hibernate" "shutdown" "reboot" "windows"]);
  };
}
