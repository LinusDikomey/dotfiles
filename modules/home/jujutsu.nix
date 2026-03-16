{dotfiles, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = dotfiles.user.name;
        email = dotfiles.user.email;
      };
      ui.default-command = "log";
      aliases.tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
    };
  };
}
