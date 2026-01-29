{
  lib,
  config,
  pkgs,
  localPkgs,
  dotfiles,
  ...
}: let
  cfg = config.dotfiles.gaming;
in {
  options.dotfiles.gaming = {
    enable = lib.mkEnableOption "Enable packages and programs for gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (
        prismlauncher.override
        {
          jdks = [jdk8 jdk17 jdk25];
        }
      )
      localPkgs.waywall
      localPkgs.ninjabrain-bot
      olympus
      jemalloc
      xdotool
      xorg.xwininfo
    ];

    home.file = let
      mk = p: config.lib.file.mkOutOfStoreSymlink "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/${p}";
    in {
      ".config/xkb/symbols/mc".source = mk "config/waywall/mc";
      ".config/waywall".source = mk "config/waywall/";
    };
  };
}
