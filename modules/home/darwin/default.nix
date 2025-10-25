{
  pkgs,
  dotfiles,
  lib,
  inputs,
  ...
}: {
  programs.nushell.extraConfig = lib.mkIf pkgs.stdenv.isDarwin ''
    $env.PATH = ($env.PATH
      | append $"($env.HOME)/nix-profile/bin"
      | append "/etc/profiles/per-user/${dotfiles.username}/bin"
      | append "/run/current-system/sw/bin"
      | append "/nix/var/nix/profiles/default/bin"
      | append "/usr/local/bin"
    )
    $env.NIX_PATH = "nixpkgs=${inputs.nixpkgs}"
  '';
  home = lib.mkIf pkgs.stdenv.isDarwin {
    extraActivationPath = with pkgs; [
      rsync
      dockutil
      gawk
    ];
    activation.makeTrampolineApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${builtins.readFile ./make-app-trampolines.sh}
        fromDir="$HOME/Applications/Home Manager Apps"
        toDir="$HOME/Applications/Home Manager Trampolines"
        sync_trampolines "$fromDir" "$toDir"
    '';

    file.".hushlogin".text = "";
  };
}
