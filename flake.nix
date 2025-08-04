{
  description = "Linus Dikomey's Nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
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
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eye = {
      url = "github:LinusDikomey/eyelang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waldbot = {
      url = "github:LinusDikomey/waldbot";
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
      wallpaper = ./wallpaper.png;
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
          inputs.lix-module.nixosModules.default
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
          inputs.lix-module.nixosModules.default
        ];
      };
  in {
    nixosConfigurations.saturn = mkNixos ./hosts/saturn.nix "linus";
    darwinConfigurations.mars = mkDarwin ./hosts/mars.nix "linus";
    nixosConfigurations.titan = mkNixos ./hosts/titan.nix "linus";
    deploy.nodes.titan = {
      hostname = "192.168.2.108";
      profiles.system = {
        sshUser = "root";
        magicRollback = false;
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.titan;
      };
    };
    nixosConfigurations.neptune = mkNixos ./hosts/neptune.nix "linus";
    deploy.nodes.neptune = {
      hostname = "78.47.87.53";
      profiles.system = {
        sshUser = "root";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.neptune;
      };
    };
  };
}
