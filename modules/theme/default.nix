{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  variants = import ./variants.nix;
  defaults = import ./values.nix pkgs;
in {
  options.dotfiles.theme = {
    font = lib.mkOption {
      type = types.submodule {
        options = {
          package = lib.mkOption {
            type = types.package;
            description = "Font package";
          };
          name = lib.mkOption {
            type = types.str;
            description = "Font family name";
          };
        };
      };
      default = defaults.theme.font;
    };
    wallpaper = lib.mkOption {
      type = types.path;
      default = defaults.theme.wallpaper;
    };
    variant = lib.mkOption {
      type = types.enum (builtins.attrNames variants);
      default = defaults.theme.variant;
    };
    accent = lib.mkOption {
      type = types.str;
      default = defaults.theme.accent;
    };
    colors = lib.mkOption {
      default = defaults.theme.colors;
    };
  };
}
