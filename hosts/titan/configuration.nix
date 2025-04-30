{
  pkgs,
  dotfiles,
  inputs,
  username,
  ...
}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  dotfiles.dyndns.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";

  networking.hostName = "titan";
  time.timeZone = "Europe/Berlin";
  users.users.root.openssh.authorizedKeys.keys = [
    dotfiles.users.linus.key
  ];
  users.users.linus.openssh.authorizedKeys.keys = [
    dotfiles.users.linus.key
  ];
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["root" username];
      UseDns = false;
    };
  };
  age.identityPaths = ["/root/.ssh/id_ed25519"];
  networking.firewall.allowedTCPPorts = [22 2049];

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}
