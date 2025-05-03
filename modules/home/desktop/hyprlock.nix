{
  lib,
  config,
  ...
}: {
  programs.hyprlock = lib.mkIf config.dotfiles.desktop.enable {
    enable = true;

    settings = {
      background = {
        monitor = "";
        path = "$HOME/wallpaper.png";
        color = "rgba(25, 20, 20, 0.5)";
        blur_passes = 4;
        blur_size = 2;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      input-field = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 1;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgb(000000)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = {
        monitor = "";
        text = "Enter your password to unlock";
        color = "rgba(200, 200, 200, 1.0)";
        font_size = 25;
        font_family = "Fira Code Mono"; # TODO: desktop font constant

        position = "0, 200";
        halign = "center";
        valign = "center";
      };
    };
  };
}
