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
    deploy-rs.url = "github:serokell/deploy-rs";
    eye = {
      url = "github:LinusDikomey/eyelang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
    users.linus = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUBLt7DvAGEwZptMihw1RWYM3jEHV9U5h7ugQpb8m3s";
      name = "Linus Dikomey";
      email = "l.dikomey03@gmail.com";
    };
    dotfilesFor = user: homeFolder: {
      inherit inputs homeFolder users;
      username = user;
      user = users.${user};
    };
    mkNixos = host: user:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs.dotfiles = dotfilesFor user "home";
        modules = [
          host
          ./modules
          ./modules/nixos
          inputs.home-manager.nixosModules.default
          inputs.agenix.nixosModules.default
        ];
      };
    mkDarwin = host: user:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs.dotfiles = dotfilesFor user "Users";
        modules = [
          host
          ./modules
          ./modules/darwin
          inputs.home-manager.darwinModules.home-manager
          inputs.agenix.darwinModules.default
        ];
      };
  in {
    nixosConfigurations.saturn = mkNixos ./hosts/saturn/configuration.nix "linus";
    darwinConfigurations.mars = mkDarwin ./hosts/mars/configuration.nix "linus";
    nixosConfigurations.titan = mkNixos ./hosts/titan/configuration.nix "linus";
    deploy.nodes.titan = {
      hostname = "192.168.2.108";
      profiles.system = {
        sshUser = "root";
        magicRollback = false;
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.titan;
      };
    };
  };
}
