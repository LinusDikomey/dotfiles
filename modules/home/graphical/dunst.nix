{
  lib,
  config,
  ...
}: {
  services.dunst = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    settings = {
      global = {
        width = 700;
        height = 500;
        offset = "11x11";
        origin = "top-right";
        transparency = 40;
        frame_color = "#aaaaaa00";
        font = "Monospace 18";
        separator_height = 2;
        padding = 30;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 0;
        gap_size = 10;
        min_icon_size = 32;
        max_icon_size = 128;
      };

      urgency_normal = {
        background = "#181825";
        foreground = "#cdd6f4";
        timeout = 10;
      };

      urgency_critical = {
        background = "#f38ba8";
        foreground = "#ffffff";
        frame_color = "#f38ba8";
        timeout = 0;
      };
      urgency_low = {
        background = "#181825";
        foreground = "#cdd6f4";
        timeout = 6;
      };
    };
  };
}
