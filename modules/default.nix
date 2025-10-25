{
  pkgs,
  dotfiles,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    channel.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  users.users.${dotfiles.username}.shell = pkgs.nushell;

  home-manager = {
    backupFileExtension = "bak";
    users."${dotfiles.username}".imports = [./home];
  };
}
