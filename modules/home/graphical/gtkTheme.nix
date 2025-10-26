{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dotfiles.graphical.gtkTheme;
in {
  options.dotfiles.graphical.gtkTheme = {
    enable = lib.mkEnableOption "Enable GTK theming config";
  };
  config = lib.mkIf cfg.enable {
    # KDE can override this file so that home manager fails to activate after. It gets regenerated
    # when gtk is enabled here so just delete it
    home.activation.cleargtkrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      rm ~/.gtkrc-2.0
    '';
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
      size = 15;
    };
  };
}
