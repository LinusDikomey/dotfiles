{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel" "wireguard"];
  boot.extraModulePackages = [];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/66ef51db-c6d0-4da6-a1ad-9ca9d9cd1d69";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/644D-0E5B";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/224A39FF4A39CFF1";
    fsType = "ntfs";
    options = ["nofail"];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024;
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
}
