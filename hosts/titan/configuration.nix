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

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
    "/media" = {
      device = "/dev/disk/by-uuid/1da8c454-61fe-4825-8867-8a62ed17a2d6";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {
      device = "/media/swapfile";
      size = 32 * 1024;
    }
  ];
}
