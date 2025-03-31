{
  lib,
  pkgs,
  ...
}: {
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    # can be replaced with official package when it gets merged
    # https://github.com/NixOS/nixpkgs/pull/309327
    (pkgs.callPackage ../packages/olympus/package.nix {})
    (pkgs.callPackage ../packages/waywall/package.nix {})
  ];
}
