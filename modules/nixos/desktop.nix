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
  op1w = lib.any (graphical: (graphical.enable or false) && (graphical.op1w-mouse or false)) graphicalCfgs;
in {
  config = lib.mkIf enabled {
    environment.systemPackages = [
      config.dotfiles.theme.font.package
    ];

    qt.enable = true;
    programs = {
      xwayland.enable = true;
      hyprland.enable = lib.mkIf (builtins.elem "hyprland" desktops) true;
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [obs-pipewire-audio-capture];
      };
      niri = lib.mkIf (builtins.elem "niri" desktops) {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };

    services = {
      flatpak.enable = true;
      printing.enable = true;
      udev.extraRules = lib.mkIf op1w ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3367", ATTRS{idProduct}=="1970", MODE="0660", GROUP="users", TAG+="uaccess"
      '';
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      upower.enable = true;
      resolved.enable = true;
      mullvad-vpn.enable = true;
    };

    hardware = {
      enableRedistributableFirmware = true;
      keyboard.zsa.enable = true;
      bluetooth = {
        enable = true;
        settings.General.Experimental = true;
      };
    };
    boot.extraModprobeConfig = ''
      options snd-usb-audio autosuspend=0
    '';
  };
}
