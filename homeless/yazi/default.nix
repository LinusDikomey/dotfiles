{
  callHomeless,
  pkgs,
  ...
}: let
  keymap = callHomeless ./keymap.nix;
  tomlFormat = pkgs.formats.toml {};
  configDir = pkgs.linkFarm "yazi-config" [
    {
      name = "keymap.toml";
      path = tomlFormat.generate "keymap.toml" keymap;
    }
  ];
in
  pkgs.symlinkJoin {
    name = "yazi";
    buildInputs = [pkgs.makeWrapper];
    paths = [pkgs.yazi];
    postBuild = ''
      wrapProgram $out/bin/yazi \
        --set YAZI_CONFIG_HOME ${configDir}
    '';
    meta = pkgs.yazi.meta;
  }
