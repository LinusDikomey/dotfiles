{
  dotfiles,
  pkgs,
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

  users.users.${dotfiles.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  networking = {
    firewall.enable = true;
  };

  security.rtkit.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";
}
