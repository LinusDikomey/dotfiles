{
  lib,
  pkgs,
  config,
  dotfiles,
  ...
}: let
  # graphicalCfgs =
  #   lib.mapAttrsToList
  #   (user: hmConfig: hmConfig.dotfiles.graphical)
  #   config.home-manager.users;
  # enabled = lib.any (lib.map (graphical: graphical.enable or false)) graphicalCfgs;
in {
  config = lib.mkIf false {
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
