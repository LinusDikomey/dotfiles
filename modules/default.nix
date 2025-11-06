{
  pkgs,
  dotfiles,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (final: prev: {
      inherit (prev.lixPackageSets.stable) nixpkgs-review nix-eval-jobs nix-fast-build colmena;
    })
  ];
  nix.package = pkgs.lixPackageSets.stable.lix;

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
