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
      let keep = 10

      mkdir $src
      mkdir $dir

      cd $dir

      for $item in (ls $src) {
        let name = $item.name | path basename
        ln -sfn $item.name $name
      }

      chown "${dotfiles.username}" -R $dir

      loop {
        ls
          | where type != symlink
          | sort-by -r modified
          | skip $keep
          | each {
            print $"Deleting ($in.name)"
            rm -rf $in.name
          }
        sleep 300sec
      }
    '';
in {
  config = lib.mkIf enabled {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    programs.gamemode.enable = true;
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
        ExecStart = "${tmpfs-mc}/bin/tmpfs-mc";
        Restart = "always";
        RestartSec = 5;
        TimeoutSec = 0;
      };
    };
    environment.systemPackages = [tmpfs-mc];
  };
}
