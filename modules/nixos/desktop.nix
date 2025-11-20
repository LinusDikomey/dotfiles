{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  graphicalCfgs =
    lib.mapAttrsToList
    (user: hmConfig: hmConfig.dotfiles.graphical)
    config.home-manager.users;
  enabled = lib.any (graphical: graphical.enable or false) graphicalCfgs;
  desktops = lib.flatten (lib.map (graphical: graphical.desktops or []) graphicalCfgs);
  niriEnabled = builtins.elem "niri" desktops;
in {
  config = {
    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];

    qt.enable = enabled;
    programs = lib.mkIf enabled {
      xwayland.enable = true;
      niri = lib.mkIf niriEnabled {
        enable = true;
        package = pkgs.niri-unstable;
      };
      hyprland.enable = lib.mkIf (builtins.elem "hyprland" desktops) true;
    };
  };
}
