{dotfiles, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = dotfiles.user.name;
        email = dotfiles.user.email;
      };
      ui = {
        paginate = "never";
        default-command = "log";
      };
    };
  };
}
