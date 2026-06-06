{
  config,
  callHomeless,
  ...
}: {
  programs.noctalia = {
    enable = config.dotfiles.graphical.enable;
    package = callHomeless ../../../homeless/noctalia;
  };
}
