{
  lib,
  config,
  ...
}: let
  cfg = config.dotfiles.blocky;
in {
  options.dotfiles.blocky.enable = lib.mkEnableOption "Blocky DNS server with ad/malware filtering";

  config = lib.mkIf cfg.enable (let
    port = 53;
  in {
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = port;
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
        ];
        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        blocking = {
          denylists.ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          clientGroupsBlock.default = ["ads"];
        };
      };
    };
    networking.firewall = {
      allowedTCPPorts = [port];
      allowedUDPPorts = [port];
    };
  });
}
