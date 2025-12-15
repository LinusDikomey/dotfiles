{
  dotfiles,
  pkgs,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = dotfiles.user.name;
        email = dotfiles.user.email;
      };
      ui = {
        default-command = "log";

        pager = "${pkgs.delta}/bin/delta";
        diff-formatter = ":git";
      };
      aliases.tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
    };
  };
}
