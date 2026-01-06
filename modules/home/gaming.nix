{
  lib,
  config,
  pkgs,
  localPkgs,
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
      localPkgs.waywall
      localPkgs.glfw-waywall
      localPkgs.ninjabrain-bot
      # (pkgs.jdk17.override {enableJavaFX = true;})
    ];

    home.file.".config/waywall".source =
      config.lib.file.mkOutOfStoreSymlink
      "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/modules/home/waywall/";
  });
}
