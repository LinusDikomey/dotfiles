{
  config,
  pkgs,
  username,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    thunderbird

    # can be replaced with official package when it gets merged
    # https://github.com/NixOS/nixpkgs/pull/309327
    (pkgs.callPackage ../../packages/olympus/package.nix {})
  ];

  programs.ghostty.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = import ../../modules/hyprland.nix;
  };
  services.hyprpaper = {
    enable = true;
    settings = import ../../modules/hyprpaper.nix;
  };
  services.dunst = {
    enable = true;
    settings = import ../../modules/dunst.nix;
  };

  programs.waybar = import ../../modules/waybar {inherit pkgs;};

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

  services.mpris-proxy.enable = true;
}
