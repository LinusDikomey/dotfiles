{
  dotfiles,
  lib,
  ...
}: {
  home-manager.users.${dotfiles.username} = {
    dotfiles = {
      graphical.enable = true;
      coding.enable = true;
      work.enable = true;
    };
    programs.zed-editor.enable = lib.mkForce false; # currently broken on unstable
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
