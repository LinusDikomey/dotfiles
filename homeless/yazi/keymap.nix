{lib, ...}: let
  def = lib.mapAttrsToList (on: run: {inherit on run;});
in {
  mgr.prepend_keymap = def {
    "m" = "leave";
    "n" = "arrow next";
    "e" = "arrow prev";
    "i" = "enter";
    "M" = "back";
    "I" = "forward";
    "N" = "seek 5";
    "E" = "seek -5";
  };
}
