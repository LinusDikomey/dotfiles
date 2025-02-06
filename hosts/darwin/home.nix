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

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    vlc-bin
  ];

  home.file.".hushlogin".text = "";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
