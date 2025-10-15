{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.ghostty = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ghostty
      else null;
    settings = {
      theme = "Catppuccin Macchiato";
      font-family = config.dotfiles.graphical.font.name;
      font-size = 20;
      background-opacity = 0.8;
      macos-option-as-alt = lib.mkIf pkgs.stdenv.isDarwin true;
    };
  };
}
