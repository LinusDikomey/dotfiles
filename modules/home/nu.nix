{config, ...}: {
  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
    settings = {
      show_banner = false;
      rm.always_trash = true;
      cursor_shape.emacs = "line";
      use_kitty_protocol = true;
      hooks.pre_prompt = [
        # attempt at automatic activation of flake devShells
        #
        # (lib.hm.nushell.mkNushellInline
        #   ''
        #     {||
        #       if (
        #         ("flake.nix" | path exists)
        #         and ($env.IN_NIX_SHELL? | is-empty)
        #         and (nix flake show --json | from json | get devShells? | is-not-empty)
        #       ) {
        #         print "Activating Nix flake environment"
        #         nix develop --command nu
        #       }
        #     }
        #   '')
      ];
    };
    shellAliases = {
      ":q" = "exit";
      cat = "bat";
      icat = "kitten icat";
      mv = "mv -i";
      "nix develop" = "nix develop --command nu";
      "nix shell" = "nix shell";
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
      '';
  };
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
