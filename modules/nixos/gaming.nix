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
  tmpfs-mc = pkgs.writeShellScriptBin "tmpfs-mc" ''
    echo "Setting up ..."
    SRC="/home/${dotfiles.username}/mcsr/saves"
    DIR="/tmpfs/mc/saves"
    KEEP=10

    mkdir -p "$SRC"
    mkdir -p "$DIR"
    for item in "$SRC"/*; do
      ln -sfn "$item" "$DIR/$(basename "$item")"
    done
    chown "${dotfiles.username}" -R "$DIR"

    cd "$DIR" || exit 1

    while true; do
      for save in $(
        find . -maxdepth 1 -mindepth 1 ! -type l \
          -printf '%T@ %f\n' \
        | sort -nr \
        | ${pkgs.gawk}/bin/awk '{print $2}' \
        | tail -n +11
      ); do
        echo "Deleting" "$save"
        rm -rf -- "$save"
      done
      sleep 300
    done
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
