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
        core.whitespace = "error";
        init.defaultBranch = "main";
        status = {
          showStash = true;
          showUntrackedFiles = "all";
        };
        pull.rebase = true;
        rebase.autoStash = true;
      };
      hooks.pre-commit = let
        rg = "${pkgs.ripgrep}/bin/rg";
        # string is split here so that it itself doesn't trigger the filter when commiting this
        str = "NOCHECKI" + "N";
      in
        pkgs.writeShellScript "git-nocheckin-hook" ''
          if git commit -v --dry-run | ${rg} '${str}' >/dev/null 2>&1
          then
            echo "Trying to commit non-committable code."
            echo "Remove the ${str} string and try again."
            git commit -v --dry-run | ${rg} '${str}'
            exit 1
          else
            exit 0
          fi
        '';
    };
  };
}
