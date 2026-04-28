{
  config,
  pkgs,
  inputs',
}:
with pkgs; (
  [
    nushell
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
    (pkgs.writers.writeNuBin "rgd"
      #nu
      ''
        def --wrapped main [...rest] {
          ${lib.getExe pkgs.ripgrep} ...$rest --json | ${lib.getExe pkgs.delta}
        }
      '')
  ]
  ++ lib.optionals config.dotfiles.coding.enable [
    clang
    llvmPackages_19.clang-tools
    lldb_19
    inkscape
    nixd
    nil
    inputs'.eye.packages.default
    mise
    zapp
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    vlc-bin
  ]
  ++ lib.optionals (pkgs.stdenv.isLinux && config.dotfiles.coding.enable) [
    wineWow64Packages.stable
  ]
  ++ lib.optionals (pkgs.stdenv.isLinux && config.dotfiles.graphical.enable) [
    kdePackages.kolourpaint
    drawy
  ]
)
