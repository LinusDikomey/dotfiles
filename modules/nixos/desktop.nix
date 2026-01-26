{
  lib,
  config,
  pkgs,
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
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [obs-pipewire-audio-capture];
      };
    };

    services = {
      flatpak.enable = true;
      printing.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      resolved.enable = true;
      mullvad-vpn.enable = true;
    };

    hardware.enableRedistributableFirmware = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
