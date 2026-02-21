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
            {
              label = " ";
              type = "toggle";
              command = ''
                [[ $SWAYNC_TOGGLE_STATE == true ]] && (
                  systemd-inhibit \
                    --why='User request via swaync' \
                    --what=sleep:handle-lid-switch \
                    sh -c 'echo "$$" > "$XDG_RUNTIME_DIR/swaync-idle.pid"; while true; do sleep 7200; done'
                ) || kill $(<"$XDG_RUNTIME_DIR/swaync-idle.pid")
              '';
              update-command = ''kill -0 $(<"$XDG_RUNTIME_DIR/swaync-idle.pid") && echo true || echo false'';
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
          .toggle:checked {
            background-color: ${config.dotfiles.theme.colors.green};
          };
        '';
    };
    home.packages = [
      (pkgs.writeShellScriptBin "inhibiting"
        ''
          if [[ "''${1:-}" != "--" ]]; then
            echo "Usage: $0 -- program [args...]"
            exit 1
          fi
          shift

          if [[ $# -eq 0 ]]; then
            echo "Error: no program specified"
            exit 1
          fi

          swaync-client --inhibitor-add "$1"

          "$@"
          exit_code=$?

          swaync-client --inhibitor-remove "$1"

          exit $exit_code
        '')
    ];
  };
}
