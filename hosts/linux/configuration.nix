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

  boot.supportedFilesystems = ["ntfs"];
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
    networkmanagerapplet
    wlogout
    grim
    slurp
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*" "1532:006e:4d3e9afd"];
        settings = {
          main = {
            mouse2 = "f3";
          };
        };
      };
    };
  };

  systemd.user.services.polkit-lxqt-authentication-agent = {
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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

  services.samba = {
    enable = true;
    settings.global = {
      "client min protocol" = "NT1";
      "name resolve order" = "bcast host lmhosts wins";
    };
  };
  services.gvfs.enable = true;
  services.avahi.enable = true;

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
