{
  lib,
  config,
  pkgs,
  homeFolder,
  username,
  inputs,
  ...
}: {
  imports = [
    ./nu.nix
    ./mime.nix
    ./hyprlandDesktop
    ./gtkTheme.nix
    ./work.nix
    ./darwin
  ];

  home.username = username;
  home.homeDirectory = "/${homeFolder}/${username}";

  home.packages = with pkgs; (
    [
      # graphical applications
      firefox
      discord
      obsidian
      spotify
      signal-desktop-bin
      thunderbird

      # cli tools
      git
      jujutsu
      helix
      neovim
      wget
      ripgrep
      bat
      btop
      imagemagick
      zip
      unzip
      killall
      tmux
      inputs.agenix.packages.${system}.default

      # compilers and stuff
      clang
      llvmPackages_19.clang-tools
      lldb_19
      cargo
      rustc
      clippy
      rustfmt
      rust-analyzer
      texlive.combined.scheme-full
      texlab
      inkscape
      nixd
      alejandra
      inputs.eye.packages.${pkgs.system}.default

      # fonts
      pkgs.nerd-fonts.iosevka
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      unityhub
      obs-studio
      blueman
      anytype
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      vlc-bin
    ]
  );

  fonts.fontconfig.enable = true;

  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.ghostty
      else null;
    settings = {
      theme = "catppuccin-macchiato";
      font-family = "Iosevka Nerd Font";
      font-size = 20;
    };
  };

  home.file = let
    linkConfig = name: config.lib.file.mkOutOfStoreSymlink "/${homeFolder}/${username}/dotfiles/config/${name}";
    treeSitterEye = pkgs.fetchFromGitHub {
      owner = "LinusDikomey";
      repo = "tree-sitter-eye";
      rev = "96eea2d00bbb4ed06fa29d22f7f508124abe01bc";
      sha256 = "sha256-K14lGWjIztdBuM/kgoWXTSVn1tKzKrAqX3l91cqM/Ak=";
    };
  in {
    ".config/helix/config.toml".source = linkConfig "helix/config.toml";
    ".config/helix/languages.toml".source = linkConfig "helix/languages.toml";
    ".config/helix/runtime/queries/eye/locals.scm".source = "${treeSitterEye}/queries/locals.scm";
    ".config/helix/runtime/queries/eye/highlights.scm".source = "${treeSitterEye}/queries/highlights.scm";
    ".config/wlogout/".source = linkConfig "wlogout";
    ".config/wofi/".source = linkConfig "wofi";
    ".config/zed/".source = linkConfig "zed";
  };

  home.sessionVariables = {
    EDITOR = "hx";
    TERM = "xterm-256color";
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
