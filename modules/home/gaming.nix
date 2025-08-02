{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.gaming;
in {
  options.dotfiles.gaming = {
    enable = lib.mkEnableOption "Enable packages and programs for gaming";
  };

  config.home.packages = lib.mkIf cfg.enable (with pkgs; [
    prismlauncher
    olympus
    (pkgs.callPackage ../../packages/waywall/package.nix {})
    (pkgs.callPackage ../../packages/glfw-waywall/package.nix {})
    (pkgs.callPackage ../../packages/ninjabrain-bot/package.nix {})
    (pkgs.jdk23.override {enableJavaFX = true;})
  ]);
}
