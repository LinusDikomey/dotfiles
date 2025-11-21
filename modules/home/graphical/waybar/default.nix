{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.graphical;
in {
  options.dotfiles.graphical.city = lib.mkOption {
    type = lib.types.str;
    description = "City used for displaying weather in status bar";
  };

  config.programs.waybar = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        output =
          lib.lists.findFirst
          (name: cfg.monitors.${name}.primary)
          null
          (builtins.attrNames cfg.monitors);
        layer = "top";
        position = "top";
        height = 40;
        modules-left = ["hyprland/workspaces" "niri/workspaces" "hyprland/mode" "hyprland/scratchpad" "custom/music"];
        modules-center = [
          "hyprland/window"
          "niri/window"
        ];
        modules-right = ["tray" "idle_inhibitor" "wireplumber" "custom/weather" "cpu" "memory" "backlight" "battery" "battery#bat2" "clock" "custom/power"];
        "hyprland/workspaces".all-outputs = true;
        "keyboard-state" = {
          numlock = false;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        "hyprland/mode".format = "<span style=\"italic\">{}</span>";
        "hyprland/scratchpad" = {
          "format" = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = ["" ""];
          "tooltip" = true;
          "tooltip-format" = "{app}: {title}";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        clock = {
          format = "{:%d.%m. %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}%  ";
          tooltip = false;
        };
        memory = {
          format = "{}%  ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr}  ";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠ ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "     ";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          format-icons = [
            " "
            " "
            " "
          ];
          on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };
        "custom/music" = let
          p = args: "${pkgs.playerctl}/bin/playerctl ${args}";
        in {
          format = "<span foreground='#66dc69'>󰓇 </span> {icon}  <span>{text}</span>";
          return-type = "json";
          max-length = 80;
          exec = p ''-p spotify metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click = p "-p spotify play-pause";
          on-double-click = p "-p spotify next";
          on-click-right = p "-p spotify previous";
          on-scroll-down = p "-p spotify volume 0.02-";
          on-scroll-up = p "-p spotify volume 0.02+";

          format-icons = {
            Playing = "<span foreground='#E5B9C6'>󰐌 </span>";
            Paused = "<span foreground='#928374'>󰏥 </span>";
          };
        };
        "custom/power" = {
          format = "⏻ ";
          on-click = "${pkgs.wlogout}/bin/wlogout";
        };
        "custom/weather" = {
          format = "{}";
          tooltip = true;
          interval = 3600;
          exec = let
            args = {
              libraries = [pkgs.python3Packages.requests];
              flakeIgnore = ["E501" "F541" "E226"];
            };
            script = builtins.readFile ./waybar-wttr.py;
            wttr = pkgs.writers.writePython3 "waybar-wttr" args script;
          in
            pkgs.writeShellScript "waybar-wttr-wrapped" ''
              WTTR_CITY="${cfg.city}" exec ${wttr}
            '';
          return-type = "json";
        };
      }
    ];
    style =
      # Source: https://github.com/rubyowo/dotfiles/blob/f925cf8e3461420a21b6dc8b8ad1190107b0cc56/config/waybar
      /*
      css
      */
      ''
        @define-color base   #24273a;
        @define-color mantle #1e2030;
        @define-color crust  #181926;

        @define-color text     #cad3f5;
        @define-color subtext0 #a5adcb;
        @define-color subtext1 #b8c0e0;

        @define-color surface0 #363a4f;
        @define-color surface1 #494d64;
        @define-color surface2 #5b6078;

        @define-color overlay0 #6e738d;
        @define-color overlay1 #8087a2;
        @define-color overlay2 #939ab7;

        @define-color blue      #8aadf4;
        @define-color lavender  #b7bdf8;
        @define-color sapphire  #7dc4e4;
        @define-color sky       #91d7e3;
        @define-color teal      #8bd5ca;
        @define-color green     #a6da95;
        @define-color yellow    #eed49f;
        @define-color peach     #f5a97f;
        @define-color maroon    #ee99a0;
        @define-color red       #ed8796;
        @define-color mauve     #c6a0f6;
        @define-color pink      #f5bde6;
        @define-color flamingo  #f0c6c6;
        @define-color rosewater #f4dbd6;

        * {
          font-family: ${config.dotfiles.graphical.font.name};
          font-size: 22px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 5px 5px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          font-weight: bold;
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem 0.8rem;
          margin: 0 3px;
        }

        #workspaces button.active {
          color: @sky;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @sapphire;
          border-radius: 1rem;
        }

        #custom-music {
          color: @;
          border-radius: 1rem;
        }

        #window {
          background-color: @surface0;
          margin: 5px 5px;
          padding: 0px 15px;
          border-radius: 1rem;
        }

        window#waybar.empty #window {
         background:none;
        }

        #custom-music,
        #idle_inhibitor,
        #wireplumber,
        #cpu,
        #memory,
        #temperature,
        #backlight,
        #clock,
        #battery,
        #custom-lock,
        #custom-power,
        #custom-updates,
        #tray,
        #custom-weather {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }

        #clock {
          color: @blue;
        }

        #battery {
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #backlight, #battery {
            border-radius: 0;
        }

        #idle_inhibitor {
          color: @sky;
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 1rem;
        }

        #wireplumber {
          color: @maroon;
        }

        #cpu {
          color: @mauve;
        }

        #memory {
          color: @teal;
        }

        #custom-weather {
          color: @peach;
        }

        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }

        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }

        tooltip {
          background-color: @surface0;
          border: none;
        }
      '';
  };
}
