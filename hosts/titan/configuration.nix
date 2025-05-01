{
  pkgs,
  dotfiles,
  ...
}: {
  imports = [
    "${dotfiles.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  dotfiles = {
    dyndns.enable = true;
    ssh = {
      enable = true;
      allowed = {
        root = ["linus"];
        linus = ["linus"];
      };
    };
    blocky.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "titan";

  age.identityPaths = ["/root/.ssh/id_ed25519"];

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # boot = {
  #   kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
  # };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/media" = {
      device = "/dev/disk/by-uuid/1da8c454-61fe-4825-8867-8a62ed17a2d6";
      fsType = "ext4";
      options = ["nofail"];
    };
    "/export/media" = {
      device = "/media";
      options = ["bind"];
    };
  };

  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
      /export       192.168.0.0/16(rw,no_subtree_check,fsid=0)
      /export/media 192.168.0.0/16(rw,nohide,insecure,no_subtree_check)
    '';
  };
  networking.firewall = let
    ports = [111 2049 4000 4001 4002 20048];
  in {
    allowedTCPPorts = ports;
    allowedUDPPorts = ports;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 3 * 1024;
    }
  ];

  hardware.enableRedistributableFirmware = true;
}
