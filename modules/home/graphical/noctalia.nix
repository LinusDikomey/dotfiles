{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.noctalia = lib.mkIf (pkgs.stdenv.isLinux && config.dotfiles.graphical.enable) {
    enable = config.dotfiles.graphical.enable;
    # This is a bit stupid but the desktop config options need to be passed in to noctalia
    # for desktop-specific config. Maybe this should become a reusable function again.
    package = import ../../../homeless/noctalia {
      inherit pkgs;
      callHomeless =
        rec {
          callHomeless = path: import path {inherit pkgs callHomeless inputs config;};
        }.callHomeless;
    };
  };
}
