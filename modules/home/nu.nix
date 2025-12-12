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

        def --wrapped "," [program, ...args] {
          nix run $"nixpkgs#($program)" -- ...$args
        }
      ''
      + lib.optionalString config.dotfiles.coding.enable ''
        use ($nu.default-config-dir | path join mise.nu)
      '';
    extraEnv = lib.mkIf config.dotfiles.coding.enable ''
      let mise_path = $nu.default-config-dir | path join mise.nu
      ${pkgs.mise}/bin/mise activate nu | save $mise_path --force
    '';
  };

  home.shell.enableNushellIntegration = true;
}
