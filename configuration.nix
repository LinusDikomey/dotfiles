{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  time.timeZone = "Europe/Berlin";

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-sugar-dark";
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.users.linus = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.nushell;
  };

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    wpa_supplicant
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
    playerctl
    pavucontrol
    wl-clipboard
    wofi
    nautilus

    git
    jujutsu
    helix
    neovim
    wget
    firefox
    ghostty
    kitty
    nushell
    carapace
    starship
    zip
    unzip
    killall
    btop
    imagemagick
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.steam.enable = true;
  virtualisation.docker.enable = true;

  home-manager = {
    users = {
      "linus" = import ./home.nix;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 8000];
    allowedUDPPorts = [9];
  };

  networking.interfaces.enp4s0.wakeOnLan.enable = true;

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["linus"];
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  services.fail2ban.enable = true;

  system.stateVersion = "24.11";
}
