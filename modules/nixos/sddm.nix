{
  lib,
  pkgs,
  config,
  dotfiles,
  ...
}: let
  enabled =
    lib.any
    ({value, ...}: value.dotfiles.graphical.enable or false)
    (lib.attrsToList config.home-manager.users);
in {
  config = lib.mkIf enabled {
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";
    services.displayManager.sddm = {
      enable = true;
      package = lib.mkForce pkgs.kdePackages.sddm;
      theme = "catppuccin-macchiato";
    };
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "macchiato";
        font = "Iosevka Nerd Font";
        fontSize = "10";
        background = "${dotfiles.wallpaper}";
        loginBackground = true;
      })
    ];
  };
}
