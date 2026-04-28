{
  lib,
  config,
  dotfiles,
  inputs,
  pkgs,
  inputs',
  ...
}: {
  options.dotfiles.coding.enable = lib.mkEnableOption "Enable coding packages";

  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
    inputs.agenix.homeManagerModules.default

    ./darwin
    ./gaming.nix
    ./graphical
    ./git.nix
    ./helix
    ./jujutsu.nix
    ./keymap
    ./less.nix
    ./mime.nix
    ./nh.nix
    ./nu.nix
    ./shell.nix
    ./work.nix
    ./yazi.nix
  ];

  config = {
    home.username = dotfiles.username;
    home.homeDirectory = "/${dotfiles.homeFolder}/${dotfiles.username}";
    home.sessionVariables.XDG_CONFIG_HOME = "/${dotfiles.homeFolder}/${dotfiles.username}/.config";

    fonts.fontconfig.enable = true;

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };

    home.packages = import ./packages.nix {inherit pkgs config inputs';};

    home.shellAliases = lib.mkIf config.dotfiles.coding.enable {
      "objdump" = "objdump -M intel";
    };

    programs.home-manager.enable = true;
    home.stateVersion = "26.05";
  };
}
