{
  lib,
  pkgs,
  config,
  dotfiles,
  ...
}: let
  cfg = config.dotfiles.sddm;
in {
  options.dotfiles.sddm = {
    enable = lib.mkEnableOption "Enable SDDM Login Shell";
  };
  config = lib.mkIf cfg.enable {
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
