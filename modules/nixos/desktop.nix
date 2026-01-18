{
  lib,
  config,
  ...
}: let
  graphicalCfgs =
    lib.mapAttrsToList
    (user: hmConfig: hmConfig.dotfiles.graphical)
    config.home-manager.users;
  enabled = lib.any (graphical: graphical.enable or false) graphicalCfgs;
  desktops = lib.flatten (lib.map (graphical: graphical.desktops or []) graphicalCfgs);
in {
  config = {
    qt.enable = enabled;
    programs = lib.mkIf enabled {
      xwayland.enable = true;
      hyprland.enable = lib.mkIf (builtins.elem "hyprland" desktops) true;
    };
    services = {
      printing.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      resolved.enable = true;
      mullvad-vpn.enable = true;
    };
  };
}
