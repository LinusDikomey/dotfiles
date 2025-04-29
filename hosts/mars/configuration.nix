{username, ...}: {
  home-manager.users.${username} = {
    dotfiles = {
      graphical.enable = true;
      coding.enable = true;
      work.enable = true;
    };
  };
}
