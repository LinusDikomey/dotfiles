{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.work;
in {
  options.dotfiles.work = {
    enable = lib.mkEnableOption "Enable work-related packages and programs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        slack
        keepassxc
        google-chrome
        wireguard-tools
        graphite-cli
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        teams
      ];
  };
}
