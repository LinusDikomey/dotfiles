{dotfiles, ...}: {
  home-manager.users.${dotfiles.username}.dotfiles = {
    graphical.enable = true;
    coding.enable = true;
    work.enable = true;
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
