{
  config,
  lib,
  pkgs,
  inputs',
  ...
}: {
  programs.noctalia = lib.mkIf (pkgs.stdenv.isLinux && config.dotfiles.graphical.enable) {
    enable = config.dotfiles.graphical.enable;
    package = inputs'.self.packages.noctalia;
  };
}
