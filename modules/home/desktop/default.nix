{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.desktop;
in {
  imports = [
    ./dunst.nix
    ./gammastep.nix
    ./hypridle.nix
    ./hyprland
    ./hyprlock.nix
    ./hyprpaper.nix
    ./waybar
  ];
  options.dotfiles.desktop = {
    enable = lib.mkEnableOption "Enable desktop support";
    nvidia = lib.mkEnableOption "Enable support for nvidia GPU hardware";
    desktops = lib.mkOption {
      type = types.listOf (types.enum ["hyprland"]);
      default = ["hyprland"];
    };
    monitors = lib.mkOption {
      type = types.listOf types.attrs;
      # TODO: more specific type for list elements like this:
      # {
      #   primary = types.bool;
      #   output = types.str;
      #   resolution = types.str;
      #   framerate = types.int;
      #   offset = types.str;
      #   scale = types.float;
      # };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wpa_supplicant
      networkmanagerapplet
      grim
      slurp
      wl-clipboard
      nautilus
      lxqt.lxqt-policykit

      kitty #backup terminal
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services.network-manager-applet.enable = true;
    services.mpris-proxy.enable = true;

    systemd.user.services.polkit-lxqt-authentication-agent = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Service = {
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
