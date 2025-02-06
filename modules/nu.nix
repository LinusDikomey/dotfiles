{username}: {
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
  };
  shellAliases = {
    ":q" = "exit";
    cat = "bat";
    icat = "kitten icat";
    mv = "mv -i";
    "nix develop" = "nix develop --command nu";
  };
}
