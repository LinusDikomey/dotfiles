{dotfiles, ...}: let
  inherit (dotfiles) username;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "saturn";

  home-manager.users."${username}" = {
    dotfiles = {
      graphical.enable = true;
      coding.enable = true;
      desktop = {
        enable = true;
        nvidia = true;
        gtkTheme.enable = true;
        monitors = [
          {
            primary = true;
            output = "DP-4";
            resolution = "3840x2160";
            framerate = 60;
            offset = "0x0";
            scale = 1.5;
          }
          {
            output = "HDMI-A-5";
            resolution = "1920x1080";
            framerate = 60;
            offset = "2560x720";
            scale = 1;
          }
        ];
        city = "Aachen";
      };
    };
  };

  dotfiles = {
    gaming.enable = true;
    sddm.enable = true;
    ssh.enable = true;
  };

  age.identityPaths = ["/home/linus/.ssh/id_ed25519"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["ntfs" "nfs"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs = {
    hyprland.enable = true;
    nix-ld.enable = true;
  };

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    resolved.enable = true;
    mullvad-vpn.enable = true;
  };

  virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 8000 25565];
    allowedUDPPorts = [9];
  };
  networking.interfaces.enp4s0.wakeOnLan.enable = true;

  fileSystems."/mnt/media" = {
    device = "192.168.2.108:/media";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  };
}
