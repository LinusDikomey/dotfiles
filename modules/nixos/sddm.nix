{
  lib,
  pkgs,
  config,
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
      theme = "catppuccin-${config.dotfiles.theme.variant}-${config.dotfiles.theme.accent}";
    };
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = config.dotfiles.theme.variant;
        accent = config.dotfiles.theme.accent;
        font = config.dotfiles.theme.font.name;
        fontSize = "10";
        # background = "${dotfiles.wallpaper}";
        loginBackground = true;
      })
    ];
  };
}
