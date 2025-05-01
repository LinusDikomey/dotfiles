{dotfiles, ...}: {
  imports = [
    ./gaming.nix
    ./sddm.nix
    ./dyndns.nix
    ./ssh.nix
    ./blocky.nix
  ];

  users.users.${dotfiles.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  networking.firewall.enable = true;

  system.stateVersion = "24.11";
}
