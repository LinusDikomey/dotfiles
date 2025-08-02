{
  lib,
  config,
  ...
}: let
  enabled =
    lib.any
    ({value, ...}: value.dotfiles.gaming.enable or false)
    (lib.attrsToList config.home-manager.users);
in {
  config = lib.mkIf enabled {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
  };
}
