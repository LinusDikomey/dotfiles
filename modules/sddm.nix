{
  lib,
  pkgs,
  config,
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

      # kde sets the next options, override them
      package = lib.mkForce pkgs.libsForQt5.sddm;
      extraPackages = pkgs.lib.mkForce (with pkgs; [
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtgraphicaleffects
        libsForQt5.qt5.qtsvg
      ]);
      theme = "${import ../packages/sddm-theme.nix {inherit pkgs;}}";
    };
  };
}
