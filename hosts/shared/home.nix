{
  config,
  pkgs,
  homeFolder,
  username,
  lib,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/${homeFolder}/${username}";

  home.packages = with pkgs; [
    # graphical applications
    discord-canary
    obsidian
    prismlauncher
    spotify
    signal-desktop

    # cli tools
    git
    jujutsu
    helix
    neovim
    wget
    ripgrep
    bat
    carapace
    starship
    btop
    imagemagick

    # compilers and stuff
    clang
    llvmPackages_18.clang-tools
    cargo
    rustc
    clippy
    rustfmt
    rust-analyzer
    lldb
    texlive.combined.scheme-full
    texlab
    inkscape
    nixd
    alejandra
  ];

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/${homeFolder}/${username}/dotfiles/config/${name}";
  in {
    ".config/ghostty/".source = linkConfig "ghostty";
    ".config/helix/".source = linkConfig "helix";
    ".config/wlogout/".source = linkConfig "wlogout";
    ".config/wofi/".source = linkConfig "wofi";
    ".config/zed/".source = linkConfig "zed";
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.git = {
    enable = true;
    userName = "Linus Dikomey";
    userEmail = "l.dikomey03@gmail.com";
    lfs.enable = true;
    ignores = [
      ".obsidian"
      ".DS_Store"
    ];
  };

  # programs.ghostty.enable = true;
  programs.nushell = import ../../modules/nu.nix {inherit username lib;};
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
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
