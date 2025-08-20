{
  lib,
  config,
  pkgs,
  dotfiles,
  ...
}: {
  options.dotfiles.coding.enable = lib.mkEnableOption "Enable coding packages";

  config.home.packages = with pkgs; (
    [
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
      dotfiles.inputs.eye.packages.${pkgs.system}.default
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      vlc-bin
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      wineWowPackages.stable
    ]
  );
  config.home.shellAliases = lib.mkIf config.dotfiles.coding.enable {
    "objdump" = "objdump -M intel";
  };
}
