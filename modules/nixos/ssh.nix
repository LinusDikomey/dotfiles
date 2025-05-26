{
  lib,
  config,
  dotfiles,
  ...
}: let
  inherit (lib) types;
  cfg = config.dotfiles.ssh;
in {
  options.dotfiles.ssh = {
    enable = lib.mkEnableOption "Enable access via ssh";
    allowed = lib.mkOption {
      type = types.nullOr (types.attrsOf (types.listOf (types.enum (builtins.attrNames dotfiles.users))));
      default = {
        ${dotfiles.username} = [dotfiles.username];
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [22];
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        AllowUsers =
          if cfg.allowed == null
          then null
          else builtins.attrNames cfg.allowed;
        UseDns = false;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    users.users = lib.mkIf (cfg.allowed != null) (
      builtins.mapAttrs (name: allowedUsers: {
        openssh = {
          authorizedKeys.keys = map (allowed: dotfiles.users.${allowed}.key) allowedUsers;
        };
      })
      cfg.allowed
    );
    services.fail2ban.enable = false; # can be enabled but caused trouble for me
  };
}
