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
          (name: cfg.monitors.${name}.primary or false)
          null
          (builtins.attrNames cfg.monitors);
        layer = "top";
        position = "top";
        height = 40;
        modules-left = [
          "custom/music"
        ];
        modules-center = [
          "niri/workspaces"
        ];
        modules-right = [
          "tray"
          "wireplumber"
          "custom/weather"
          "cpu"
          "memory"
          "backlight"
          "battery"
          "clock"
          "custom/notifications"
        ];
        "keyboard-state" = {
          numlock = false;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
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
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            iso8601 = true;
            format = {
              months = "<span color='#1976d2'><b>{}</b></span>";
              weekdays = "<span color='#1976d2'><b>{}</b></span>";
              days = "<span color='#fafafa'><b>{}</b></span>";
              today = "<span color='#1976d2'><b>{}</b></span>";
              weeks = "<span color='#1976d2'><b>{}</b></span>";
            };
            weeks-pos = "right";
            on-scroll = 1;
          };
          format-alt = "{:%Y-%m-%d}";
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
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
        "niri/workspaces" = {
          format = " ";
          all-outputs = true;
        };
        "custom/music" = let
          p = args: "${pkgs.playerctl}/bin/playerctl ${args}";
        in {
          format = "<span foreground='#66dc69'>󰓇 </span> {icon}  <span>{text}</span>";
          return-type = "json";
          max-length = 80;
          exec = let
            cmd = p ''-p spotify metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          in
            pkgs.writers.writeNu "waybar-music"
            #nu
            ''
              if (swaync-client --get-dnd) == "true" { return }
              ${cmd}
            '';
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
        "custom/notifications" = {
          tooltip = true;
          format = "<span size='16pt'>{icon}</span>";
          format-icons = {
            notification = "󱅫 ";
            none = "󰂜 ";
            dnd-notification = "󰂠 ";
            dnd-none = "󰪓 ";
            inhibited-notification = "󰂛 ";
            inhibited-none = "󰪑 ";
            dnd-inhibited-notification = "󰂛 ";
            dnd-inhibited-none = "󰪑 ";
          };
          return-type = "json";
          exec = "swaync-client -swb";
          on-click = "swaync-client --toggle-panel -sw";
          on-click-right = "swaync-client --toggle-dnd -sw";
          escape = true;
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
    style = let
      colors = config.dotfiles.theme.colors;
    in
      # css
      ''
        * {
          font-family: ${config.dotfiles.theme.font.name};
          font-size: 22px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: ${colors.text};
          margin: 5px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 5px 5px;
          background-color: ${colors.surface0};
        }

        #workspaces button {
          font-weight: bold;
          color: ${colors.lavender};
          border-radius: 1rem;
          padding: 0.2rem;
          /* padding: 0.4rem 0.8rem;
          margin: 0 3px; */
        }

        #workspaces button.active {
          color: ${colors.sky};
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: ${colors.sapphire};
          border-radius: 1rem;
        }

        #custom-music {
          border-radius: 1rem;
          margin-left: 4px;
        }

        #window {
          background-color: ${colors.surface0};
          margin: 5px 5px;
          padding: 0px 15px;
          border-radius: 1rem;
        }

        window#waybar.empty #window {
         background:none;
        }

        #custom-notifications,
        #custom-music {
          color: ${colors.text};
        }

        #wireplumber,
        #cpu,
        #memory,
        #temperature,
        #backlight,
        #clock,
        #battery,
        #custom-lock,
        #custom-updates,
        #tray,
        #custom-weather,
        #custom-notifications,
        #custom-music {
          background-color: ${colors.surface0};
          padding: 0.5rem 0.75rem;
          margin-top: 4px;
          margin-bottom: 4px;
        }

        /* leftmost module */
        #wireplumber {
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 4px;
        }

        /* rightmost module */
        #custom-notifications {
            margin-right: 4px;
            border-radius: 0px 1rem 1rem 0px;
            color: ${colors.red};
        }

        #clock {
          color: ${colors.blue};
        }

        #battery {
          color: ${colors.green};
        }

        #battery.charging {
          color: ${colors.green};
        }

        #battery.warning:not(.charging) {
          color: ${colors.red};
        }

        #backlight {
          color: ${colors.yellow};
        }

        #backlight, #battery {
            border-radius: 0;
        }

        #wireplumber {
          color: ${colors.maroon};
        }

        #cpu {
          color: ${colors.mauve};
        }

        #memory {
          color: ${colors.teal};
        }

        #custom-weather {
          color: ${colors.peach};
        }

        #tray {
          margin-right: 4px;
          border-radius: 1rem;
        }

        tooltip {
          background-color: ${colors.surface0};
          border: none;
        }
      '';
  };
}
