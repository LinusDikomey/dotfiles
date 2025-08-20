{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
    settings = {
      show_banner = false;
      rm.always_trash = true;
      cursor_shape.emacs = "line";
      use_kitty_protocol = true;
    };
    shellAliases = {
      ":q" = "exit";
      cat = "${pkgs.bat}/bin/bat";
      icat = "${pkgs.kitty}/bin/kitten icat";
      mv = "mv -i";
      "nix develop" = "nix develop --command nu";
    };
    extraConfig =
      /*
      nu
      */
      ''
        def ips [] {
          let external = http get https://checkip.amazonaws.com | str trim
          sys net
            | each {|v|
              let ips = $v.ip
                | where protocol == 'ipv4'
                | get address
              { name: $v.name, ip: $ips.0? }
            }
            | where ip != null
            | prepend {name: 'external', ip: $external }
        }

        def tokei [...args] {
          ${pkgs.tokei}/bin/tokei ...$args
            | lines
            | each { str trim }
            | where {|s| not (
              ($s | str starts-with '━') or
              ($s | str starts-with '─') or
              ($s | str starts-with '|') or
              ($s | str starts-with '('))
            }
            | split column -r '\s+'
            | headers
        }
      '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git.ignores = lib.mkIf config.dotfiles.git.enable [".direnv/"];
}
