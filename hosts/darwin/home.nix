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

  programs.nushell.extraConfig = ''
    $env.PATH = ($env.PATH
      | append $"($env.HOME)/nix-profile/bin"
      | append "/etc/profiles/per-user/${username}/bin"
      | append "/run/current-system/sw/bin"
      | append "/nix/var/nix/profiles/default/bin"
      | append "/usr/local/bin"
    )
  '';
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
