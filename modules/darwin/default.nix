{
  pkgs,
  inputs,
  username,
  homeFolder,
  ...
}: {
  imports = [
    ./link-applications.nix
  ];

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

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
