{
  pkgs,
  callHomeless,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
  settings = callHomeless ./settings.nix;
  configDir = pkgs.linkFarm "noctalia-config" [
    {
      name = "settings.json";
      path = jsonFormat.generate "noctalia-settings.json" settings;
    }
  ];
in
  pkgs.symlinkJoin {
    name = "noctalia-shell";
    buildInputs = [pkgs.makeWrapper];
    paths = [pkgs.noctalia-shell];
    postBuild = ''
      wrapProgram $out/bin/noctalia-shell \
        --set NOCTALIA_CONFIG_DIR ${configDir}
    '';
    meta = pkgs.noctalia-shell.meta;
  }
