{username, ...}: {
  imports = [
    ./gaming.nix
    ./sddm.nix
    ./dyndns.nix
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  system.stateVersion = "24.11";
}
