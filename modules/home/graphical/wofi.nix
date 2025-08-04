{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.wofi = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    enable = true;
    settings = {
      show = "drun";
      sort_order = "default";
      width = "30%";
      hide_scroll = true;
      lines = 8;
      term = "ghostty";
      line_wrap = "word";
      allow_markup = true;
      always_parse_args = false;
      show_all = true;
      print_command = true;
      layer = "overlay";
      allow_images = true;
      gtk_dark = true;
      prompt = "Search";
      image_size = 24;
      display_generic = false;
      location = "center";
      insensitive = false;
    };
    style =
      # css
      ''
        * {
          font-family: Iosevka;
          color: #cdd6f4;
        }

        #outer-box {
          padding: 20px;
        }

        #window {
          background: #11111b;
          margin: auto;
          padding: 10px;
          border-radius: 20px;
          border: 2px solid #89b4fa;
        }

        #input {
          padding: 10px 20px;
          margin-bottom: 10px;
          border-radius: 90px;
        }

        #img {
          margin-right: 6px;
        }

        #text {
          margin: 2px;
        }

        #entry {
          padding: 10px;
          border-radius: 90px;
          border: none;
        }

        #entry:selected {
          background-color: #313244;
          outline: none;
          border: none;
        }
      '';
  };
}
