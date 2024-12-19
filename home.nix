{ config, pkgs, ... }:

{
  home.username = "linus";
  home.homeDirectory = "/home/linus";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # graphical applications
    discord-canary
    obsidian
    thunderbird
    prismlauncher

    # can be replaced with official package when it gets merged
    # https://github.com/NixOS/nixpkgs/pull/309327
    (pkgs.callPackage ./packages/olympus/package.nix { })

    # cli tools
    ripgrep
    bat

    # compilers and stuff
    clang
    rustup
    lldb
    texlive.combined.scheme-full
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

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

  programs.git = {
    enable = true;
    userName = "Linus Dikomey";
    userEmail = "l.dikomey03@gmail.com";
  };

  services.mpris-proxy.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
