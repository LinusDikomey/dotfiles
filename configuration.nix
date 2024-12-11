{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;

  services.printing.enable = true;
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.users.linus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.nushell;
  };

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    waybar
    networkmanagerapplet
    gammastep
    hypridle
    hyprlock
    dunst
    wlogout
    grim
    slurp
    pulseaudio # still using pipewire but need pactl for scripts for now
    pavucontrol
    wl-clipboard
    wofi
    nautilus

    git
    helix
    neovim
    wget
    firefox
    kitty
    nushell
    carapace
    starship
    zip
    unzip
    killall
    btop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.steam.enable = true;

  home-manager = {
    users = {
      "linus" = import ./home.nix;
    };
  };

  system.stateVersion = "24.11";

}
