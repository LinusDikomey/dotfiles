{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.nushell;
  };

  programs.hyprland.enable = true;

  services.desktopManager.plasma6.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
  };

  environment.systemPackages = with pkgs; [
    wpa_supplicant
    hyprpaper
    waybar
    networkmanagerapplet
    gammastep
    hypridle
    hyprlock
    wlogout
    grim
    slurp
    pulseaudio # still using pipewire but need pactl for scripts for now
    playerctl
    pavucontrol
    wl-clipboard
    wofi
    nautilus
    lxqt.lxqt-policykit

    firefox
    kitty
    nushell
    zip
    unzip
    killall
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 8000];
    allowedUDPPorts = [9];
    # used for samba network storage discovery
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  services.samba.enable = true;
  services.gvfs.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  networking.interfaces.enp4s0.wakeOnLan.enable = true;

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [username];
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  services.fail2ban.enable = true;

  system.stateVersion = "24.11";
}
