{
  lib,
  config,
  pkgs,
  ...
}: let
  graphicalCfgs =
    lib.mapAttrsToList
    (user: hmConfig: hmConfig.dotfiles.graphical)
    config.home-manager.users;
  enabled = lib.any (graphical: graphical.enable or false) graphicalCfgs;
  nvidia = lib.any (graphical: graphical.nvidia or false) graphicalCfgs;
in {
  config = {
    hardware.graphics = lib.mkIf enabled {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = lib.mkIf (enabled && nvidia) {
      package = let
        base = config.boot.kernelPackages.nvidiaPackages.beta;
        # patch fixes this issue: https://github.com/NixOS/nixpkgs/issues/489947
        cachyos-nvidia-patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/refs/heads/master/6.19/misc/nvidia/0003-Fix-compile-for-6.19.patch";
          hash = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
        };
      in
        base
        // {
          open = base.open.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or []) ++ [cachyos-nvidia-patch];
          });
        };
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
    };
    services.xserver.videoDrivers = lib.optional nvidia "nvidia";
    systemd.services.systemd-suspend = lib.mkIf nvidia {
      # fix for sleep on nvidia breaking things
      serviceConfig.Environment = ''
        "SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"
      '';
    };
  };
}
