{
  config,
  callHomeless,
  ...
}: {
  programs.noctalia-shell = {
    enable = config.dotfiles.graphical.enable;
    package = callHomeless ../../../homeless/noctalia;
  };
}
