{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}: {
  options.dotfiles = {
    graphical.enable = lib.mkEnableOption "Enable graphical packages";
    coding.enable = lib.mkEnableOption "Enable coding packages";
  };

  config.home.packages = with pkgs; (
    [
      jujutsu
      neovim
      dotfiles.inputs.agenix.packages.${system}.default
      wget
      ripgrep
      bat
      btop
      imagemagick
      zip
      unzip
      killall
      tmux
      dig
    ]
    ++ lib.optionals config.dotfiles.graphical.enable [
      pkgs.nerd-fonts.iosevka

      firefox
      discord
      obsidian
      spotify
      signal-desktop-bin
      thunderbird
      qbittorrent
    ]
    ++ lib.optionals config.dotfiles.coding.enable [
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
      dotfiles.inputs.eye.packages.${pkgs.system}.default
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux
      && config.dotfiles.graphical.enable) [
      unityhub
      obs-studio
      blueman
      anytype
      mullvad-vpn
      vlc
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      vlc-bin
    ]
  );
}
