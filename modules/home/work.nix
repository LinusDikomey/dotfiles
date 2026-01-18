{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.work;
in {
  options.dotfiles.work = {
    enable = lib.mkEnableOption "Enable work-related packages and programs";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
      wireguard-tools
      graphite-cli
      kubectl
      kubecolor
      awscli
      terraform-ls
    ];

    home.shellAliases.k = "kubecolor";
    home.sessionVariables.KUBECONFIG = "${config.home.homeDirectory}/roofline/k3s.yaml";

    xdg.configFile."carapace/specs/kubecolor.yaml".text = ''
      # yaml-language-server: $schema=https://carapace.sh/schemas/command.json
      name: kubecolor
      completion:
        positionalany: ["$carapace.bridge.Cobra([kubectl])"]
    '';
  };
}
