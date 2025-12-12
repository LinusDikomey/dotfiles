{
  pkgs,
  lib,
  config,
  ...
}: {
  home.shellAliases = {
    ":q" = "exit";
    cat = "${pkgs.bat}/bin/bat";
    icat = "${pkgs.kitty}/bin/kitten icat";
  };

  programs.carapace.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git.ignores = lib.mkIf config.dotfiles.git.enable [".direnv/"];

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
}
