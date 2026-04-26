{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.graphical;
in {
  imports = [
    ./firefox.nix
    ./gammastep.nix
    ./gtkTheme.nix
    ./kitty.nix
    ./modkeys.nix
    ./niri.nix
    ./noctalia.nix
    ./waybar
    ./wlogout
    ./zed.nix
  ];

  options.dotfiles.graphical = {
    enable = lib.mkEnableOption "Enable graphical and desktop support";
    nvidia = lib.mkEnableOption "Enable support for nvidia GPU hardware";
    desktops = lib.mkOption {
      type = types.listOf (types.enum ["niri"]);
      default = [];
    };
    monitors = lib.mkOption {
      type = types.attrsOf types.attrs;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        config.dotfiles.theme.font.package

        vesktop
        obsidian
        spotify
        signal-desktop
        qbittorrent
        keymapp
        # bitwarden-desktop
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wpa_supplicant
        networkmanagerapplet
        wl-clipboard
        nautilus
        crosspipe
        lxqt.lxqt-policykit

        blueman
        mullvad-vpn
        vlc
        kdePackages.kdenlive
      ];

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };

    xdg.portal = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      xdgOpenUsePortal = true;
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
    };

    services = lib.mkIf pkgs.stdenv.isLinux {
      polkit-gnome.enable = true;
      gnome-keyring.enable = true;
      network-manager-applet.enable = true;
      mpris-proxy.enable = true;
    };
  };
}
