{
  pkgs,
  dotfiles,
  inputs,
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

  system.primaryUser = dotfiles.username;
  system.defaults = {
    LaunchServices.LSQuarantine = false;
    NSGlobalDomain = {
      InitialKeyRepeat = 20;
      KeyRepeat = 4;
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

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 6 * 1024;
        };
        cores = 6;
      };
    };
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nixpkgs.config.allowBroken = true;
  system.stateVersion = 6;
}
