{ config, pkgs, ... }:

{
  home.username = "linus";
  home.homeDirectory = "/home/linus";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # graphical applications
    discord-canary
    obsidian

    # cli tools
    ripgrep
    bat

    # compilers and stuff
    clang
    rustup
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
