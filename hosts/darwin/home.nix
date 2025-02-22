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

  home.extraActivationPath = with pkgs; [
    rsync
    dockutil
    gawk
  ];
  home.activation.makeTrampolineApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${builtins.readFile ./make-app-trampolines.sh}
      fromDir="$HOME/Applications/Home Manager Apps"
      toDir="$HOME/Applications/Home Manager Trampolines"
      sync_trampolines "$fromDir" "$toDir"
  '';

  home.packages = with pkgs; [
    vlc-bin
  ];

  home.file.".hushlogin".text = "";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
