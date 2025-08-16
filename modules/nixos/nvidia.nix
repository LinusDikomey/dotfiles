{
  lib,
  config,
  ...
}: let
  graphicalCfgs =
    lib.mapAttrsToList
    (user: hmConfig: hmConfig.dotfiles.graphical)
    config.home-manager.users;
  enabled = lib.any (graphical: graphical.enable or false) graphicalCfgs;
  nvidia = lib.any (graphical: graphical.nvidia or false) graphicalCfgs;
in {
  config = lib.mkIf enabled {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = lib.mkIf nvidia {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
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
