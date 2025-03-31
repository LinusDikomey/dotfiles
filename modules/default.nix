{
  pkgs,
  inputs,
  username,
  homeFolder,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  time.timeZone = "Europe/Berlin";

  users.users.${username}.shell = pkgs.nushell;

  home-manager = {
    users."${username}".imports = [./home];
    extraSpecialArgs = {inherit inputs username homeFolder;};
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
