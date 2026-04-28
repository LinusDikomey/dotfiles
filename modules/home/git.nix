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
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
      ignores = [
        ".obsidian"
        ".DS_Store"
        ".codex"
      ];
      settings = {
        user = {
          name = dotfiles.user.name;
          email = dotfiles.user.email;
        };
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

    age.secrets.uni-git.file = ../../secrets/uni-git.gitconfig;
    # can't use the config path directly because it contains an env var substitution for
    # XDG_RUNTIME_DIR which git doesn't substitute
    home.activation.gitSecret = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.config/git"
      ln -sf "${config.age.secrets.uni-git.path}" \
        "$HOME/.config/git/uni-git"
    '';
    programs.git.includes = [
      {
        condition = "gitdir:~/dev/uni/**";
        path = "~/.config/git/uni-git";
      }
    ];
  };
}
