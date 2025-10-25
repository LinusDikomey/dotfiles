{
  lib,
  config,
  pkgs,
  inputs',
  ...
}: {
  options.dotfiles.coding.enable = lib.mkEnableOption "Enable coding packages";

  config.home.packages = with pkgs; (
    [
      neovim
      inputs'.agenix.packages.default
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
    ++ lib.optionals config.dotfiles.coding.enable [
      clang
      llvmPackages_19.clang-tools
      lldb_19
      cargo
      rustc
      clippy
      rustfmt
      rust-analyzer
      inkscape
      nixd
      nil
      inputs'.eye.packages.default
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      vlc-bin
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux && config.dotfiles.coding.enable) [
      wineWowPackages.stable
    ]
  );
  config.home.shellAliases = lib.mkIf config.dotfiles.coding.enable {
    "objdump" = "objdump -M intel";
  };
}
