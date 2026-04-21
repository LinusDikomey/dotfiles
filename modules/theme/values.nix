pkgs: let
  variants = import ./variants.nix;
in {
  inherit pkgs;
  inherit (pkgs) lib;
  theme = rec {
    font = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font Mono";
    };
    wallpaper = ../../wallpapers/sagittarius_a.png;
    variant = "macchiato";
    accent = "blue";
    colors = variants.${variant};
  };
  keymap = import ../home/keymap/colemak_dh.nix;
}
