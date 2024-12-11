{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTE: This will require your git SSH access to the repo.
    #
    # WARNING:
    # Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    #
    # Additionally, if you use NixOS, be sure to **NOT**
    # run `nixos-rebuild` as root! Root has a different Git config
    # that will ignore any SSH keys configured for the current user,
    # denying access to the repository.
    #
    # Instead, either run `nix flake update` or `nixos-rebuild build`
    # as the current user, and then run `sudo nixos-rebuild switch`.
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ghostty, ... }: {
    nixosConfigurations.mysystem = nixpkgs.lib.nixosSystem {
      modules = [
        {
          environment.systemPackages = [
            ghostty.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}
