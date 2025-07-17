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

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      prismlauncher
      olympus
      (pkgs.callPackage ../../packages/waywall/package.nix {})
      (pkgs.callPackage ../../packages/glfw-waywall/package.nix {})
      (pkgs.callPackage ../../packages/ninjabrain-bot/package.nix {})
      (pkgs.jdk23.override {enableJavaFX = true;})
    ];
  };
}
