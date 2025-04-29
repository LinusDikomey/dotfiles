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
      # can be replaced with official package when it gets merged
      # https://github.com/NixOS/nixpkgs/pull/309327
      (pkgs.callPackage ../../packages/olympus/package.nix {})
      (pkgs.callPackage ../../packages/waywall/package.nix {})
    ];
  };
}
