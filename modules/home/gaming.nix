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
          jdks = [
            jdk8
            jdk21
            graalvmPackages.graalvm-oracle_17
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
      localPkgs.waywall
      localPkgs.ninjabrain-bot
      localPkgs.advancely
      olympus
      jemalloc
      xdotool
      xorg.xwininfo
      jdk21
    ];

    home.file = let
      mk = p: config.lib.file.mkOutOfStoreSymlink "/${dotfiles.homeFolder}/${dotfiles.username}/dotfiles/${p}";
    in {
      ".config/xkb/symbols/mc".source = mk "config/waywall/mc";
      ".config/waywall".source = mk "config/waywall/";
    };
  };
}
