{
  pkgs,
  dotfiles,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "Europe/Berlin";

  users.users.${dotfiles.username}.shell = pkgs.nushell;

  home-manager = {
    users."${dotfiles.username}".imports = [./home];
    extraSpecialArgs = {inherit dotfiles;};
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
