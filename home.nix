{
  config,
  pkgs,
  username,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/home/${username}";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # graphical applications
    discord-canary
    obsidian
    thunderbird
    prismlauncher

    # can be replaced with official package when it gets merged
    # https://github.com/NixOS/nixpkgs/pull/309327
    (pkgs.callPackage ./packages/olympus/package.nix {})

    # cli tools
    ripgrep
    bat

    # compilers and stuff
    clang
    llvmPackages_18.clang-tools
    rustup
    lldb
    texlive.combined.scheme-full
    texlab
    inkscape
    nixd
    alejandra
  ];

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/home/${username}/dotfiles/config/${name}";
  in {
    ".config/dunst/".source = linkConfig "dunst";
    ".config/gammastep/".source = linkConfig "gammastep";
    ".config/ghostty/".source = linkConfig "ghostty";
    ".config/helix/".source = linkConfig "helix";
    ".config/hypr/".source = linkConfig "hypr";
    ".config/lazygit/".source = linkConfig "lazygit";
    ".config/nushell/".source = linkConfig "nushell";
    ".config/nvim/".source = linkConfig "nvim";
    ".config/ranger/".source = linkConfig "ranger";
    ".config/starship.toml".source = linkConfig "starship.toml";
    ".config/waybar/".source = linkConfig "waybar";
    ".config/wlogout/".source = linkConfig "wlogout";
    ".config/wofi/".source = linkConfig "wofi";
    ".config/zed/".source = linkConfig "zed";
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
