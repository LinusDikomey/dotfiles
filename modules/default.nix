{
  pkgs,
  dotfiles,
  inputs,
  ...
}: {
  imports = [./theme];

  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (final: prev: {
      inherit (prev.lixPackageSets.latest) nixpkgs-review nix-eval-jobs nix-fast-build colmena;
    })
  ];
  nix.package = pkgs.lixPackageSets.latest.lix;

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    channel.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  users.users.${dotfiles.username}.shell = pkgs.nushell;

  home-manager = {
    backupFileExtension = "bak";
    users."${dotfiles.username}".imports = [
      ./home
      ./theme
    ];
  };
}
