{
  pkgs,
  dotfiles,
  ...
}: {
  config = {
    networking.hostName = "titan";
    time.timeZone = "Europe/Berlin";
    users.users.root.openssh.authorizedKeys.keys = [
      dotfiles.keys.linus
    ];
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = ["root"];
        UseDns = true;
      };
    };
    networking.firewall.allowedTCPPorts = [22 2049];

    environment.systemPackages = with pkgs; [
      git
      helix
    ];

    services.transmission = {
      enable = true;
      openRPCPort = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "127.0.0.1,192.168.*.*";
      };
    };

    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "hosts allow" = "192.168.2. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          path = "/export";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0755";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
      };
    };
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;

    system.stateVersion = "24.11";
  };
}
