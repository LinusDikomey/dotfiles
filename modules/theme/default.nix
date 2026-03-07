{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types;
  variants = import ./variants.nix;
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
      default = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
    };
    wallpaper = lib.mkOption {
      type = types.path;
      default = ../wallpapers/sagittarius_a.png;
    };
    variant = lib.mkOption {
      type = types.enum (builtins.attrNames variants);
      default = "macchiato";
    };
    accent = lib.mkOption {
      type = types.str;
      default = "blue";
    };
    colors = lib.mkOption {
      default = variants.${config.dotfiles.theme.variant};
    };
  };
}
