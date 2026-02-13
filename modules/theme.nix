{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types;
  variants = {
    macchiato = {
      base = "#24273a";
      mantle = "#1e2030";
      crust = "#181926";
      text = "#cad3f5";
      subtext0 = "#a5adcb";
      subtext1 = "#b8c0e0";
      surface0 = "#363a4f";
      surface1 = "#494d64";
      surface2 = "#5b6078";
      overlay0 = "#6e738d";
      overlay1 = "#8087a2";
      overlay2 = "#939ab7";
      blue = "#8aadf4";
      lavender = "#b7bdf8";
      sapphire = "#7dc4e4";
      sky = "#91d7e3";
      teal = "#8bd5ca";
      green = "#a6da95";
      yellow = "#eed49f";
      peach = "#f5a97f";
      maroon = "#ee99a0";
      red = "#ed8796";
      mauve = "#c6a0f6";
      pink = "#f5bde6";
      flamingo = "#f0c6c6";
      rosewater = "#f4dbd6";
    };
  };
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
