{ pkgs, inputs, ... }: {
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [];
  
  system.stateVersion = 5;
}
