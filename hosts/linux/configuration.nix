{
  pkgs,
  username,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  home-manager.users."${username}" = {
    dotfiles = {
      hyprlandDesktop.enable = true;
      gtkTheme.enable = true;
    };
  };

  dotfiles = {
    gaming.enable = true;
    sddm.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["ntfs"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  programs.hyprland.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 8000 25565];
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
      PasswordAuthentication = false;
      AllowUsers = [username];
      UseDns = false;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  services.fail2ban.enable = true;

  system.stateVersion = "24.11";
}
