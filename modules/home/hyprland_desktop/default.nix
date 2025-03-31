{pkgs}: {
  imports = [
    ./theme.nix
  ];

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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = import ./hyprland.nix;
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

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
  };

  systemd.user.services.polkit-lxqt-authentication-agent = {
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
