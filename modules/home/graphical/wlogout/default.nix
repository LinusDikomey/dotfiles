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
      # css
      ''

        * {
            background-image: none;
            box-shadow: none;
        }

        window {
            background-color: rgba(30, 30, 46, 0.9);
        }

        button {
            border-radius: 30;
            border-color: black;
            text-decoration-color: #cdd6f4;
            color: #cdd6f4;
            background-color: #313244;
            border-style: solid;
            border-width: 2px;
            border-color: #b4befe;
            margin: 20px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
        }

        button:focus, button:active, button:hover {
            background-color: #74c7ec;
            outline-style: none;
        }
      ''
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
