{
  description = "Linus Dikomey's Nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
    username = "linus";
  in {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs username;};
      modules = [
        ./hosts/shared/configuration.nix
        ./hosts/linux/configuration.nix
        {
          home-manager.users."${username}".imports = [
            ./hosts/linux/home.nix
            ./hosts/shared/home.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit username;
            homeFolder = "home";
          };
        }
        inputs.home-manager.nixosModules.default
      ];
    };
    darwinConfigurations.LinusAir = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs username;};
      modules = [
        ./hosts/shared/configuration.nix
        ./hosts/darwin/configuration.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username}.imports = [
            ./hosts/darwin/home.nix
            ./hosts/shared/home.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit username;
            homeFolder = "Users";
          };
        }
      ];
    };
  };
}
