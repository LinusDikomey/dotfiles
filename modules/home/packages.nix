{
  lib,
  config,
  pkgs,
  inputs',
  ...
}: {
  options.dotfiles.coding.enable = lib.mkEnableOption "Enable coding packages";

  config = {
    home.packages = with pkgs; (
      [
        inputs'.agenix.packages.default
        wget
        ripgrep
        bat
        btop
        imagemagick
        zip
        unzip
        file
        killall
        tmux
        dig
      ]
      ++ lib.optionals config.dotfiles.coding.enable [
        clang
        llvmPackages_19.clang-tools
        lldb_19
        inkscape
        nixd
        nil
        inputs'.eye.packages.default
        # (rust-bin.stable.latest.default.override {
        #   extensions = ["rust-analyzer" "rust-src"];
        # })
        mise
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        vlc-bin
      ]
      ++ lib.optionals (pkgs.stdenv.isLinux && config.dotfiles.coding.enable) [
        wineWow64Packages.stable
      ]
    );
    home.shellAliases = lib.mkIf config.dotfiles.coding.enable {
      "objdump" = "objdump -M intel";
    };
  };
}
