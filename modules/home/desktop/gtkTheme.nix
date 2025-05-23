{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dotfiles.desktop.gtkTheme;
in {
  options.dotfiles.desktop.gtkTheme = {
    enable = lib.mkEnableOption "Enable GTK theming config";
  };
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-macchiato-blue-standard";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          variant = "macchiato";
        };
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 18;
    };
  };
}
