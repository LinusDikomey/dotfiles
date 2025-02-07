{
  config,
  pkgs,
  homeFolder,
  username,
  lib,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/${homeFolder}/${username}";

  home.packages = with pkgs; [
    # graphical applications
    discord-canary
    obsidian
    prismlauncher
    spotify

    # cli tools
    git
    jujutsu
    helix
    neovim
    wget
    ripgrep
    bat
    carapace
    starship
    btop
    imagemagick

    # compilers and stuff
    clang
    llvmPackages_18.clang-tools
    cargo
    lldb
    texlive.combined.scheme-full
    texlab
    inkscape
    nixd
    alejandra
  ];

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/${homeFolder}/${username}/dotfiles/config/${name}";
  in {
    #".config/dunst/".source = linkConfig "dunst";
    ".config/gammastep/".source = linkConfig "gammastep";
    ".config/ghostty/".source = linkConfig "ghostty";
    ".config/helix/".source = linkConfig "helix";
    ".config/hypr/hypridle.conf".source = linkConfig "hypr/hypridle.conf";
    ".config/hypr/hyprlock.conf".source = linkConfig "hypr/hyprlock.conf";
    ".config/wlogout/".source = linkConfig "wlogout";
    ".config/wofi/".source = linkConfig "wofi";
    ".config/zed/".source = linkConfig "zed";
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.git = {
    enable = true;
    userName = "Linus Dikomey";
    userEmail = "l.dikomey03@gmail.com";
  };

  # programs.ghostty.enable = true;
  programs.nushell = import ../../modules/nu.nix {inherit username lib;};
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
