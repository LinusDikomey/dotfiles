{
  pkgs,
  dotfiles,
  ...
}: {
  imports = [
    ./link-applications.nix
  ];

  users.users.${dotfiles.username} = {
    home = "/${dotfiles.homeFolder}/${dotfiles.username}";
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

  system.configurationRevision = dotfiles.inputs.self.rev or dotfiles.inputs.self.dirtyRev or null;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
