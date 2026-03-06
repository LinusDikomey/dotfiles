{
  dotfiles,
  lib,
  config,
  pkgs,
  ...
}: let
  enabled =
    lib.any
    ({value, ...}: value.dotfiles.gaming.enable or false)
    (lib.attrsToList config.home-manager.users);
  tmpfs-mc =
    pkgs.writers.writeNuBin "tmpfs-mc"
    # nu
    ''
      echo "Setting up ..."
      let src = "/home/${dotfiles.username}/mcsr/saves"
      let dir = "/tmpfs/mc/saves"

      mkdir $src
      mkdir $dir

      cd $dir

      for $item in (ls $src) {
        let name = $item.name | path basename
        ln -sfn $item.name $name
      }

      chown "${dotfiles.username}" -R $dir
    '';
  tmpfs-mc-cleanworlds =
    pkgs.writers.writeNuBin "tmpfs-mc-cleanworlds"
    # nu
    ''
      let keep = 10
      ls /tmpfs/mc/saves
        | where type != symlink
        | sort-by -r modified
        | skip $keep
        | each {
          print $"Deleting ($in.name)"
          rm -rf --permanent $in.name
        }
    '';
in {
  config = lib.mkIf enabled {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          PROTON_ENABLE_WAYLAND = 1;
          SDL_VIDEODRIVER = "wayland";
        };
      };
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    users.users.${dotfiles.username}.extraGroups = ["gamemode"];
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings.general.renice = 10;
    };
    services.libinput.enable = true;
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Never Debounce]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';

    fileSystems."/tmpfs" = {
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=16g"
      ];
    };
    systemd.services."tmpfs-mc" = {
      description = "Setup tmpfs symlinks";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${tmpfs-mc}/bin/tmpfs-mc";
        RemainAfterExit = true;
      };
    };
    environment.systemPackages = [
      tmpfs-mc
      tmpfs-mc-cleanworlds
    ];
  };
}
