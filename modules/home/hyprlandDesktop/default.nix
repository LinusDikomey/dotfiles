{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dotfiles.hyprlandDesktop;
in {
  options.dotfiles.hyprlandDesktop = {
    enable = lib.mkEnableOption "Enable Hyprland Desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wpa_supplicant
      networkmanagerapplet
      wlogout
      grim
      slurp
      pavucontrol
      wl-clipboard
      wofi
      nautilus
      lxqt.lxqt-policykit

      kitty
    ];

    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-hyprland];
      xdgOpenUsePortal = true;
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    wayland.windowManager.hyprland = import ./hyprland.nix {inherit pkgs;};
    services.hyprpaper = {
      enable = true;
      settings = import ./hyprpaper.nix;
    };
    services.hypridle = {
      enable = true;
      settings = import ./hypridle.nix {inherit pkgs;};
    };
    services.dunst = {
      enable = true;
      settings = import ./dunst.nix;
    };
    programs.waybar = import ./waybar {inherit pkgs;};
    services.gammastep = import ./gammastep.nix;
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
