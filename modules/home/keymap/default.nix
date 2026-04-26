{
  lib,
  config,
  ...
}: {
  options.dotfiles.keymap = let
    key = default:
      lib.mkOption {
        inherit default;
        type = lib.types.singleLineStr;
      };
  in
    (lib.mapAttrs (name: value: key value) (import ./qwerty.nix))
    // {
      layout.colemak_dh = lib.mkOption {
        description = "Enable Colemak DH default layout";
        default = true;
        type = lib.types.bool;
      };
    };
  config.dotfiles.keymap = lib.mkIf config.dotfiles.keymap.layout.colemak_dh (import ./colemak_dh.nix);
}
