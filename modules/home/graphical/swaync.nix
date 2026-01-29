{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.dotfiles.graphical.enable && pkgs.stdenv.isLinux) {
    services.swaync = {
      enable = true;
      settings = {
        widgets = [
          "label"
          "buttons-grid"
          "volume"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
        widget-config = {
          label = {
            max-lines = 1;
            text = "Control Center";
          };
          buttons-grid.actions = [
            {
              label = "󰐥 ";
              command = "${pkgs.wlogout}/bin/wlogout";
            }
            {
              label = " ";
              command = "nm-connection-editor";
            }
            {
              label = "󰂯 ";
              command = "${pkgs.blueman}/bin/blueman-manager";
            }
          ];

          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "󰃢 ";
          };
          mpris.autohide = true;
          volume.label = "󰕾 ";
        };
      };
      style = let
        # get style from catppuccin/swaync
        version = "v1.0.1";
        file = "catppuccin-${config.dotfiles.theme.variant}.css";
        catppuccin = pkgs.fetchurl {
          url = "https://github.com/catppuccin/swaync/releases/download/${version}/${file}";
          hash = "sha256-jN7oHf075g463+pPtiTJl3OTXMQjQ+O+OS8L4cCTipI=";
        };
        css = builtins.readFile catppuccin;
      in
        css
        + #css
        ''
          * !important {
            font-family: ${config.dotfiles.theme.font.name};
            font-size: 22px;
          }
        '';
    };
  };
}
