{
  dotfiles,
  inputs,
  ...
}: {
  imports = [
    ./darwin
    ./gaming.nix
    ./graphical
    ./git.nix
    ./helix.nix
    ./jujutsu.nix
    ./mime.nix
    ./nh.nix
    ./nu.nix
    ./packages.nix
    ./shell.nix
    ./work.nix
    ./yazi.nix
    ./zed.nix
  ];

  home.username = dotfiles.username;
  home.homeDirectory = "/${dotfiles.homeFolder}/${dotfiles.username}";
  home.sessionVariables.XDG_CONFIG_HOME = "/${dotfiles.homeFolder}/${dotfiles.username}/.config";

  fonts.fontconfig.enable = true;

  home.sessionVariables.TERM = "xterm-256color";

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
