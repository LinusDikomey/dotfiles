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
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "nix-darwin";
      };
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
  outputs = inputs: {
    nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        homeFolder = "home";
        username = "linus";
      };
      modules = [
        ./hosts/linux/configuration.nix
        ./modules
        ./modules/nixos
        inputs.home-manager.nixosModules.default
        inputs.agenix.nixosModules.default
      ];
    };
    darwinConfigurations.LinusAir = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
        homeFolder = "Users";
        username = "linus";
      };
      modules = [
        ./hosts/darwin/configuration.nix
        ./modules
        ./modules/darwin
        inputs.home-manager.darwinModules.home-manager
        inputs.agenix.darwinModules.default
      ];
    };
  };
}
