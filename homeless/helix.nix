{
  callHomeless,
  pkgs,
}: let
  settings = callHomeless ./../modules/home/helix/settings.nix;
  languages = callHomeless ./../modules/home/helix/languages.nix;
  tomlFormat = pkgs.formats.toml {};
  configDir = pkgs.linkFarm "helix-config" [
    {
      name = "helix/config.toml";
      path = tomlFormat.generate "config.toml" settings;
    }
    {
      name = "helix/languages.toml";
      path = tomlFormat.generate "languages.toml" languages;
    }
  ];
in
  pkgs.symlinkJoin {
    name = "hx";
    buildInputs = [pkgs.makeWrapper];
    paths = [pkgs.helix];
    postBuild = ''
      wrapProgram $out/bin/hx \
        --set XDG_CONFIG_HOME ${configDir}
    '';
  }
