{
  config,
  pkgs,
  username,
  lib,
  osConfig,
  ...
}: let
  homeDirectory = "/Users/${username}";
in {
  home.username = username;
  home.homeDirectory = homeDirectory;

  programs.nushell.environmentVariables.PATH = [
    "~/.nix-profile/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vlc-bin
  ];

  home.file.".hushlogin".text = "";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
