pkgs: let
  variants = import ./modules/theme/variants.nix;
  # TODO: share the defaults with the duplicated values in ./modules/theme/default.nix
  callHomeless = path:
    import path {
      inherit (pkgs) lib;
      inherit pkgs;
      theme = rec {
        font = {
          package = pkgs.nerd-fonts.iosevka;
          name = "Iosevka Nerd Font";
        };
        wallpaper = ./../wallpapers/sagittarius_a.png;
        variant = "macchiato";
        accent = "blue";
        colors = variants.${variant};
      };
      keymap = import ./../modules/home/keymap/colemak_dh.nix;
    };
  importHomeless = path: import path {inherit pkgs callHomeless;};
in {
  helix = importHomeless ./helix.nix;
}
