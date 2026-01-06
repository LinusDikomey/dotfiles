{
  dotfiles,
  pkgs,
  ...
}: let
  inherit (dotfiles) username;
in {
  home-manager.users."${username}".dotfiles = {
    coding.enable = true;
    work.enable = true;
    gaming.enable = true;
    graphical = {
      desktops = ["hyprland" "niri"];
      enable = true;
      nvidia = true;
      gtkTheme.enable = true;
      monitors = {
        "DP-4" = {
          primary = true;
          resolution = {
            x = 3840;
            y = 2160;
          };
          framerate = 144;
          offset = {
            x = 0;
            y = 0;
          };
          scale = 1.5;
        };
        "DP-3" = {
          resolution = {
            x = 3840;
            y = 2160;
          };
          framerate = 60;
          offset = {
            x = builtins.floor (3840 / 1.5);
            y = 0;
          };
          scale = 1.5;
        };
      };
      city = "Aachen";
    };
  };

  dotfiles.ssh.enable = true;

  age.identityPaths = ["/home/linus/.ssh/id_ed25519"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["ntfs" "nfs"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
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

  virtualisation.docker.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [22 8000 25565];
      allowedUDPPorts = [9];
    };
    interfaces.enp4s0.wakeOnLan.enable = true;
    useNetworkd = false;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [obs-pipewire-audio-capture];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/66ef51db-c6d0-4da6-a1ad-9ca9d9cd1d69";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/644D-0E5B";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-uuid/224A39FF4A39CFF1";
      fsType = "ntfs";
      options = ["nofail"];
    };

    "/mnt/media" = {
      device = "192.168.2.108:/media";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=10s"
      ];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024;
    }
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "wireguard"];
  boot.extraModulePackages = [];
  hardware.cpu.intel.updateMicrocode = true;

  services.flatpak.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
