{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    dotfiles.gitea.enable = lib.mkEnableOption "gitea";
  };
  config = lib.mkIf config.dotfiles.gitea.enable {
    services.caddy = {
      enable = true;
      virtualHosts."git.exspelledgame.com".extraConfig = "reverse_proxy 127.0.0.1:3000";
    };
    services.gitea = {
      enable = true;
      user = "git";
      group = "git";
      lfs.enable = true;
      settings = {
        server = {
          SSH_USER = "git";
          SSH_DOMAIN = "exspelledgame.com";
          DOMAIN = "exspelledgame.com";
          ROOT_URL = "https://git.exspelledgame.com/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3000;
          APP_DATA_PATH = "/var/lib/gitea/data";
        };
        security.INSTALL_LOCK = true;
        service = {
          DISABLE_REGISTRATION = true;
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
          DEFAULT_ALLOW_CREATE_ORGANIZATION = true;
        };
        "service.explore" = {
          DISABLE_USERS_PAGE = true;
          DISABLE_ORGANIZATIONS_PAGE = true;
          DISABLE_CODE_PAGE = true;
        };
        packages.ENABLED = false;
      };
    };
    users.users.git = {
      shell = pkgs.bash;
      isSystemUser = true;
      group = "git";
      extraGroups = ["gitea"];
      home = "/var/lib/gitea";
    };
    users.groups.git = {};
  };
}
