{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.dotfiles.theme) variant accent;
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
        name = "catppuccin-${variant}-${accent}-standard";
        package = pkgs.catppuccin-gtk.override {
          inherit variant;
          accents = [accent];
        };
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };
    home.packages = [pkgs.glib];
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 10;
    };
  };
}
