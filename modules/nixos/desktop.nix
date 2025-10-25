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
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  programs.niri = lib.mkIf (enabled && niriEnabled) {
    enable = true;
    package = pkgs.niri-unstable;
  };
  programs.hyprland.enable = lib.mkIf (enabled && builtins.elem "hyprland" desktops) true;

  services.desktopManager.plasma6 = lib.mkIf (builtins.elem "plasma" desktops) {
    enable = true;
    enableQt5Integration = true;
  };
}
