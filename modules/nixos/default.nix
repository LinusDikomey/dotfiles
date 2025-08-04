{
  dotfiles,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./gaming.nix
    ./sddm.nix
    ./dyndns.nix
    ./ssh.nix
    ./blocky.nix
    ./desktop.nix
    ./nvidia.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.useDHCP = lib.mkDefault true;

  users.users.${dotfiles.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  networking = {
    firewall.enable = true;
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";
}
