{
  lib,
  pkgs,
  pkgs-stable,
  config,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.graphical;
in {
  imports = [
    ./dunst.nix
    ./gammastep.nix
    ./ghostty.nix
    ./hypridle.nix
    ./hyprland
    ./niri
    ./hyprlock.nix
    ./hyprpaper.nix
    ./waybar
    ./wlogout
    ./wofi.nix
    ./gtkTheme.nix
  ];

  options.dotfiles.graphical = {
    enable = lib.mkEnableOption "Enable graphical and desktop support";
    nvidia = lib.mkEnableOption "Enable support for nvidia GPU hardware";
    desktops = lib.mkOption {
      type = types.listOf (types.enum ["hyprland" "niri"]);
      default = [];
    };
    monitors = lib.mkOption {
      type = types.attrsOf types.attrs;
    };
    font = lib.mkOption {
      type = types.submodule {
        options = {
          package = lib.mkOption {
            type = types.package;
            description = "Font package";
          };
          name = lib.mkOption {
            type = types.str;
            description = "Font family name";
          };
        };
      };
      default = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        kitty #backup terminal
        config.dotfiles.graphical.font.package

        firefox
        discord
        obsidian
        spotify
        signal-desktop-bin
        qbittorrent
        bitwarden-desktop
        (pkgs.callPackage ../../packages/helium.nix {})
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wpa_supplicant
        networkmanagerapplet
        grim
        slurp
        wl-clipboard
        nautilus
        helvum
        lxqt.lxqt-policykit

        blueman
        mullvad-vpn
        vlc
        keymapp
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

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services = lib.mkIf pkgs.stdenv.isLinux {
      gnome-keyring.enable = true;
      network-manager-applet.enable = true;
      mpris-proxy.enable = true;
    };

    systemd.user.services.polkit-lxqt-authentication-agent = lib.mkIf pkgs.stdenv.isLinux {
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
