{
  lib,
  pkgs,
  localPkgs,
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
      type = types.listOf (types.enum ["hyprland"]);
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
    home.packages = let
      krisp-patcher =
        pkgs.writers.writePython3Bin "krisp-patcher"
        {
          libraries = with pkgs.python3Packages; [
            capstone
            pyelftools
          ];
          flakeIgnore = [
            "E501" # line too long (82 > 79 characters)
            "F403" # 'from module import *' used; unable to detect undefined names
            "F405" # name may be undefined, or defined from star imports: module
          ];
        }
        (
          builtins.readFile (
            pkgs.fetchurl {
              url = "https://pastebin.com/raw/8tQDsMVd";
              sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
            }
          )
        );
    in
      with pkgs;
        [
          kitty #backup terminal
          config.dotfiles.graphical.font.package

          firefox
          discord
          krisp-patcher
          obsidian
          spotify
          signal-desktop-bin
          qbittorrent
          bitwarden-desktop
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
