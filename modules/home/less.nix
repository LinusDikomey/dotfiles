{
  config,
  lib,
  ...
}: let
  inherit (config.dotfiles) keymap;
  inherit (lib) toUpper;
in {
  programs.less = {
    enable = true;
    config = ''
      #command

      ${keymap.down} forw-line
      ${keymap.up} back-line

      ${toUpper keymap.down} forw-screen
      ${toUpper keymap.up} back-screen
      ${keymap.next} repeat-search
      ${toUpper keymap.next} reverse-search
    '';
  };
}
