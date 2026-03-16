{
  pkgs,
  lib,
  config,
  ...
}: {
  home.shellAliases = let
    kitten = args: "${pkgs.kitty}/bin/kitten ${args}";
  in {
    ":q" = "exit";
    cat = "${pkgs.bat}/bin/bat";
    icat = kitten "icat";
    ssh = kitten "ssh";
    clip = kitten "clipboard";
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
