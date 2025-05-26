{
  pkgs,
  dotfiles,
  modulesPath,
  config,
  ...
}: let
  system = "aarch64-linux";
in {
  dotfiles = {
    ssh = {
      enable = true;
      allowed.root = ["linus"];
      allowed.linus = ["linus"];
    };
  };

  networking.hostName = "neptune";
  time.timeZone = "Europe/Berlin";

  services.caddy = {
    enable = true;
    virtualHosts = {
      "areweengine2yet.xyz".extraConfig = ''
        root * /www/areweengine2yet.xyz/
        file_server
      '';
      "linus.exposed".extraConfig = ''
        root * /www/linus.exposed/
        file_server
      '';
      "git.areweengine2yet.xyz".extraConfig = "reverse_proxy 127.0.0.1:3000";
    };
  };

  services.gitea = {
    enable = true;
    settings = {
      server = {
        SSH_DOMAIN = "areweengine2yet.xyz";
        DOMAIN = "areweengine2yet.xyz";
        ROOT_URL = "https://git.areweengine2yet.xyz/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        APP_DATA_PATH = "/var/lib/gitea/data";
      };
      lfs.PATH = "/var/lib/gitea/data/lfs";
      security.INSTALL_LOCK = true;
      service = {
        DISABLE_REGISTRATION = true;
      };
      packages.ENABLED = false;
    };
  };

  age.secrets.waldbot-env.file = ../secrets/waldbot-env.age;
  systemd.services.waldbot = let
    waldbot = dotfiles.inputs.waldbot.packages.${system}.default;
    envPath = config.age.secrets.waldbot-env.path;
  in {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "Waldbot";
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      User = "root";
      ExecStart = pkgs.writeShellScript "waldbot-wrapped" ''
        set -a; source ${envPath}; set +a
        ${waldbot}/bin/waldbot
      '';
      WorkingDirectory = "/var/lib/waldbot";
    };
  };

  networking.firewall.allowedTCPPorts = [22 80 443];

  age.identityPaths = ["/root/.ssh/id_ed25519"];

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  networking.useDHCP = true;

  nixpkgs.hostPlatform = system;
}
