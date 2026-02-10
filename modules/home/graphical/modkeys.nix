{
  pkgs,
  lib,
  ...
}: {
  options.dotfiles.graphical.modkeys = let
    inherit (lib) types;
  in
    lib.mkOption {
      type = let
        rawCommand = types.oneOf [types.singleLineStr (types.listOf types.singleLineStr)];
        cmdDesc = types.submodule {
          options = {
            cmd = lib.mkOption {
              description = "The command that should be executed";
              type = rawCommand;
            };
            desc = lib.mkOption {
              description = "Short description of the command";
              type = types.singleLineStr;
            };
          };
        };
        command = types.either rawCommand cmdDesc;
        commandOrCommandSet = types.attrsOf (types.either (types.attrsOf command) command);
      in
        commandOrCommandSet;
      description = "Actions performed on Mod + key press";
    };
  config.dotfiles.graphical.modkeys = let
    website = name: url: {
      cmd = "firefox ${url}";
      desc = name;
    };
  in
    lib.mkDefault {
      w = "${pkgs.firefox}/bin/firefox";
      f = "${pkgs.nautilus}/bin/nautilus";
      b = ["swaync-client" "--toggle-panel"];
      return = "${pkgs.ghostty}/bin/ghostty";
      Escape = "${pkgs.wlogout}/bin/wlogout";
      R = builtins.listToAttrs (builtins.genList (i: let
          percent =
            if i == 0
            then "100"
            else toString (i * 10);
        in {
          name = "${toString i}";
          value = {
            cmd = "niri msg action set-window-width ${percent}%";
            desc = "${percent}%";
          };
        })
        10);
      space = {
        space = {
          cmd = [
            "${pkgs.wofi}/bin/wofi"
            "--theme"
            "launcher"
            "--modi"
            "drun,run,window,ssh,filebrowser"
            "--show"
            "drun"
          ];
          desc = "Search Apps ...";
        };
        d = "discord";
        p = "spotify";
        b = {
          cmd = "blueman-manager";
          desc = "Bluetooth";
        };
        m = "prismlauncher";
        o = "obs";
        s = "steam";
        v = {
          cmd = "${pkgs.pavucontrol}/bin/pavucontrol";
          desc = "Volume Mixer";
        };
        g = website "GitHub" "https://github.com";
        y = website "YouTube" "https://youtube.com";
        t = website "Twitch" "https://twitch.tv";
      };
    };
}
