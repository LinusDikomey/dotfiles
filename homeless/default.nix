{
  pkgs,
  inputs,
  qwerty ? false,
}: let
  values =
    import ../modules/theme/values.nix pkgs
    // pkgs.lib.optionalAttrs qwerty {
      keymap = import ../modules/home/keymap/qwerty.nix;
    };
  callHomeless = path:
    import path {
      inherit pkgs callHomeless inputs;
      inherit (pkgs) lib;
      config.dotfiles = {
        inherit (values) theme keymap;
      };
    };
in {
  helix = callHomeless ./helix.nix;
  noctalia-shell = callHomeless ./noctalia;
}
