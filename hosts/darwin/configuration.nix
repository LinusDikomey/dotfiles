{username, ...}: {
  home-manager.users.${username} = {
    dotfiles = {
      work.enable = true;
    };
  };
}
