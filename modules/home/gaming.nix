{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}: let
  cfg = config.dotfiles.gaming;
in {
  options.dotfiles.gaming = {
    enable = lib.mkEnableOption "Enable packages and programs for gaming";
  };

  config = lib.mkIf cfg.enable (with pkgs; {
    home.packages = [
      prismlauncher
      olympus
      (pkgs.callPackage ../../packages/waywall/package.nix {})
      (pkgs.callPackage ../../packages/glfw-waywall/package.nix {})
      (pkgs.callPackage ../../packages/ninjabrain-bot/package.nix {})
      (pkgs.jdk17.override {enableJavaFX = true;})
    ];

    home.file.".config/waywall".source =
      config.lib.file.mkOutOfStoreSymlink
      "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/modules/home/waywall/";
  });
}
