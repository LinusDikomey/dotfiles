{
  lib,
  config,
  dotfiles,
  pkgs,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.git;
in {
  options.dotfiles.git = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.delta];
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = dotfiles.user.name;
      userEmail = dotfiles.user.email;
      ignores = [
        ".obsidian"
        ".DS_Store"
      ];
      delta.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
