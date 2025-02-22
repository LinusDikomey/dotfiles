{
  config,
  pkgs,
  username,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    thunderbird
    unityhub
    obs-studio

    # can be replaced with official package when it gets merged
    # https://github.com/NixOS/nixpkgs/pull/309327
    (pkgs.callPackage ../../packages/olympus/package.nix {})
    (pkgs.callPackage ../../packages/waywall/package.nix {})
  ];

  programs.ghostty.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 18;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      browser = "firefox.desktop";
    in {
      "image/png" = browser;
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "application/pdf" = browser;
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };

  wayland.windowManager.hyprland = import ../../modules/hyprland.nix;
  services.hyprpaper = {
    enable = true;
    settings = import ../../modules/hyprpaper.nix;
  };
  services.hypridle = {
    enable = true;
    settings = import ./settings/hypridle.nix {inherit pkgs;};
  };
  services.dunst = {
    enable = true;
    settings = import ../../modules/dunst.nix;
  };
  services.network-manager-applet.enable = true;
  services.gammastep = import ./settings/gammastep.nix;

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
