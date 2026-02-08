# preprocesses modKeys to allow for recursive (currently just two-level) binds using wlr-which-key
{
  lib,
  pkgs,
  config,
}: let
  isCmdDesc = value: lib.isAttrs value && lib.hasAttr "cmd" value;
  splitLastSlash = s: let
    m = builtins.match "(.*/)?([^/]*)" s;
  in
    if m == null
    then s
    else builtins.elemAt m 1;
in
  lib.mapAttrs (
    name: value:
      if lib.isAttrs value && !isCmdDesc value
      then let
        which-key-config = {
          anchor = "bottom-right";
          font = config.dotfiles.theme.font.name;
          background = config.dotfiles.theme.colors.base;
          menu = map ({
            name,
            value,
          }: let
            rawCmd =
              if isCmdDesc value
              then value.cmd
              else value;
          in rec {
            cmd =
              if lib.isList rawCmd
              then lib.concatStringsSep " " rawCmd
              else rawCmd;
            key = name;
            desc =
              if isCmdDesc value
              then value.desc
              else splitLastSlash cmd;
          }) (lib.attrsToList value);
        };
        configFile = pkgs.writeText "config.yaml" (lib.generators.toYAML {} which-key-config);
      in ["${pkgs.wlr-which-key}/bin/wlr-which-key" "${configFile}"]
      else if isCmdDesc value
      then value.cmd
      else value
  )
  config.dotfiles.graphical.modkeys
