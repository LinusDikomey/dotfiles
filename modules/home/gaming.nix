{
  lib,
  config,
  pkgs,
  dotfiles,
  inputs',
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
          jdks = [
            jdk8
            jdk21
            jdk25
            inputs'.mcsr.packages.graalvm-21
          ];
          additionalLibs = [
            libxkbcommon
            libxkbfile
            libx11
            libxcb
            libxinerama
            libxt
            libxtst
            libxau
            libxdmcp
            libxext
            libsm
            libice
            libbsd
            libuuid
          ];
        }
      )
      inputs'.self.packages.waywall
      inputs'.self.packages.paceman-aa-tracker
      inputs'.mcsr.packages.advancely
      inputs'.mcsr.packages.paceman-tracker
      inputs'.mcsr.packages.ninjabrain-bot
      inputs'.self.packages.waywall
      olympus
      jemalloc
      xdotool
      xwininfo
      jdk21
      ckan
    ];

    home.file = let
      mk = p: config.lib.file.mkOutOfStoreSymlink "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/${p}";
    in {
      ".config/xkb/symbols/mc".source = mk "config/waywall/mc";
      ".config/waywall".source = mk "config/waywall/";
    };
  };
}
