{
  lib,
  config,
  dotfiles,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.dotfiles.git;
in {
  options.dotfiles.git = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.programs.git = lib.mkIf cfg.enable {
    enable = true;
    lfs.enable = true;
    userName = dotfiles.user.name;
    userEmail = dotfiles.user.email;
    ignores = [
      ".obsidian"
      ".DS_Store"
    ];
  };
}
