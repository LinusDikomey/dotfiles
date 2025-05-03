{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}: {
  imports = [
    ./packages.nix
    ./nu.nix
    ./mime.nix
    ./desktop
    ./gtkTheme.nix
    ./git.nix
    ./work.nix
    ./darwin
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
    };
  };

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/config/${name}";
    treeSitterEye = pkgs.fetchFromGitHub {
      owner = "LinusDikomey";
      repo = "tree-sitter-eye";
      rev = "96eea2d00bbb4ed06fa29d22f7f508124abe01bc";
      sha256 = "sha256-K14lGWjIztdBuM/kgoWXTSVn1tKzKrAqX3l91cqM/Ak=";
    };
  in {
    ".config/helix/config.toml".source = linkConfig "helix/config.toml";
    ".config/helix/languages.toml".source = linkConfig "helix/languages.toml";
    ".config/helix/runtime/queries/eye/locals.scm".source = "${treeSitterEye}/queries/locals.scm";
    ".config/helix/runtime/queries/eye/highlights.scm".source = "${treeSitterEye}/queries/highlights.scm";
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
