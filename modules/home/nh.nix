{dotfiles, ...}: {
  programs.nh = {
    enable = true;
    flake = "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles";
  };
}
