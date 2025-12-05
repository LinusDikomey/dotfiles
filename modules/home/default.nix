{
  dotfiles,
  inputs,
  ...
}: {
  imports = [
    ./darwin
    ./graphical
    ./git.nix
    ./jujutsu.nix
    ./helix.nix
    ./mime.nix
    ./nh.nix
    ./nu.nix
    ./yazi.nix
    ./packages.nix
    ./work.nix
    ./gaming.nix
    ./zed.nix
    inputs.niri.homeModules.niri
  ];

  home.username = dotfiles.username;
  home.homeDirectory = "/${dotfiles.homeFolder}/${dotfiles.username}";

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    TERM = "xterm-256color";
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
