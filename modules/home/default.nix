{
  dotfiles,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri

    ./darwin
    ./gaming.nix
    ./graphical
    ./git.nix
    ./helix
    ./jujutsu.nix
    ./keymap
    ./less.nix
    ./mime.nix
    ./nh.nix
    ./nu.nix
    ./packages.nix
    ./shell.nix
    ./work.nix
    ./yazi.nix
  ];

  home.username = dotfiles.username;
  home.homeDirectory = "/${dotfiles.homeFolder}/${dotfiles.username}";
  home.sessionVariables.XDG_CONFIG_HOME = "/${dotfiles.homeFolder}/${dotfiles.username}/.config";

  fonts.fontconfig.enable = true;

  home.sessionVariables.TERM = "xterm-256color";

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };
  home.packages = [
    (pkgs.writers.writeNuBin "rgd"
      #nu
      ''
        def --wrapped main [...rest] {
          ${lib.getExe pkgs.ripgrep} ...$rest --json | ${lib.getExe pkgs.delta}
        }
      '')
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
}
