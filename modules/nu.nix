{
  username,
  lib,
}: {
  enable = true;
  environmentVariables = {
    # PATH = [
    #   "~/.nix-profile/bin"
    #   "/etc/profiles/per-user/${username}/bin"
    #   "/run/current-system/sw/bin"
    #   "/nix/var/nix/profiles/default/bin"
    #   "/usr/local/bin"
    #   "/usr/bin"
    #   "/bin"
    #   "/usr/sbin"
    #   "/sbin"
    # ];
    EDITOR = "hx";
    TERM = "xterm-256color";
  };
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
  };
}
