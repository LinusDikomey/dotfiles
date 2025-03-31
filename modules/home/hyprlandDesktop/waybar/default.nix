{pkgs}: {
  enable = true;
  systemd = {
    enable = true;
    target = "hyprland-session.target";
  };
  style = builtins.readFile ./style.css;
  settings = [
    {
      output = "DP-4";
      layer = "top";
      position = "top";
      height = 40;
      spacing = 8;
      modules-left = ["hyprland/workspaces" "hyprland/mode" "hyprland/scratchpad" "custom/media" "custom/spotify"];
      modules-center = ["hyprland/window"];
      modules-right = ["tray" "idle_inhibitor" "wireplumber" "custom/weather" "cpu" "memory" "temperature" "backlight" "battery" "battery#bat2" "clock" "custom/power"];
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
        on-click-right = "{pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };
      "custom/spotify" = let
        p = args: "${pkgs.playerctl}/bin/playerctl ${args}";
      in {
        format = "<span foreground='#66dc69'>󰓇 </span> {icon}  <span>{}</span>";
        return-type = "json";
        max-length = 80;
        exec = p "-p spotify metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
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
        in
          pkgs.writers.writePython3 "waybar-wttr" args script;
        return-type = "json";
      };
    }
  ];
}
