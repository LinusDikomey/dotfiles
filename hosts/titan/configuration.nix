{
  pkgs,
  dotfiles,
  ...
}: {
  imports = [
    "${dotfiles.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  dotfiles = {
    dyndns.enable = true;
    ssh.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "titan";

  age.identityPaths = ["/root/.ssh/id_ed25519"];

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/1da8c454-61fe-4825-8867-8a62ed17a2d6";
    fstype = "ext4";
  };
}
