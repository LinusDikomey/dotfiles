{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dotfiles.gtkTheme;
in {
  options.dotfiles.gtkTheme = {
    enable = lib.mkEnableOption "Enable GTK theming config";
  };
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };
      # cursorTheme = {
      #   name = "Bibata-Modern-Ice";
      #   size = 24;
      # };
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
