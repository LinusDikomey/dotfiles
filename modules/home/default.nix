{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}: {
  imports = [
    ./darwin
    ./desktop
    ./git.nix
    ./jujutsu.nix
    ./helix.nix
    ./mime.nix
    ./nu.nix
    ./packages.nix
    ./work.nix
  ];

  home.username = dotfiles.username;
  home.homeDirectory = "/${dotfiles.homeFolder}/${dotfiles.username}";

  fonts.fontconfig.enable = true;

  programs.ghostty = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ghostty
      else null;
    settings = {
      theme = "catppuccin-macchiato";
      font-family = "Iosevka Nerd Font";
      font-size = 20;
      background-opacity = 0.8;
    };
  };

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/config/${name}";
  in {
    ".config/zed/".source = linkConfig "zed";
  };

  home.sessionVariables = {
    EDITOR = "hx";
    TERM = "xterm-256color";
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
