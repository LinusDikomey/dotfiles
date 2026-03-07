{
  pkgs,
  dotfiles,
  lib,
  inputs,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.nushell.extraConfig = ''
      $env.PATH = ($env.PATH
        | append $"($env.HOME)/nix-profile/bin"
        | append "/etc/profiles/per-user/${dotfiles.username}/bin"
        | append "/run/current-system/sw/bin"
        | append "/nix/var/nix/profiles/default/bin"
        | append "/usr/local/bin"
      )
      $env.NIX_PATH = "nixpkgs=${inputs.nixpkgs}"
    '';
    home.file.".hushlogin".text = "";
  };
}
