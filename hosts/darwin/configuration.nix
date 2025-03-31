{
  pkgs,
  config,
  inputs,
  homeFolder,
  username,
  ...
}: {
  users.users.${username} = {
    home = "/${homeFolder}/${username}";
  };

  environment.systemPackages = with pkgs; [
    mkalias
  ];

  system.defaults = {
    LaunchServices.LSQuarantine = false;
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 55;
      minimize-to-application = true;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
