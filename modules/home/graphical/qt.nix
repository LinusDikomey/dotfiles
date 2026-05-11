{
  lib,
  config,
  ...
}: {
  qt = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    platformTheme.name = "gtk";
  };
}
