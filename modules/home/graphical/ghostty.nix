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
      theme = "Catppuccin ${lib.toSentenceCase config.dotfiles.theme.variant}";
      font-family = config.dotfiles.theme.font.name;
      font-size = 20;
      background-opacity = 0.8;
      macos-option-as-alt = lib.mkIf pkgs.stdenv.isDarwin true;
    };
  };
}
