{
  description = "Linus Dikomey's Nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eye = {
      url = "github:LinusDikomey/eyelang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    agenix,
    ...
  } @ inputs: let
    username = "linus";
  in {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs username;
        homeFolder = "home";
      };
      modules = [
        ./modules
        ./hosts/linux/configuration.nix
        inputs.home-manager.nixosModules.default
        agenix.nixosModules.default
      ];
    };
    darwinConfigurations.LinusAir = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs username;
        homeFolder = "Users";
      };
      modules = [
        ./modules
        ./hosts/darwin/configuration.nix
        inputs.home-manager.darwinModules.home-manager
        agenix.darwinModules.default
        {
          home-manager.users.${username}.imports = [
            ./modules/home/darwin
          ];
        }
      ];
    };
  };
}
