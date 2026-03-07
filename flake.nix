{
  description = "Linus Dikomey's Nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    eye = {
      url = "github:LinusDikomey/eyelang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    waldbot = {
      url = "github:LinusDikomey/waldbot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
    mkHost = import ./mkhost.nix {
      inherit inputs;
      users.linus = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUBLt7DvAGEwZptMihw1RWYM3jEHV9U5h7ugQpb8m3s";
        name = "Linus Dikomey";
        email = "l.dikomey03@gmail.com";
      };
      defaultUser = "linus";
    };
    mkFlake = import ./mkflake.nix {
      inherit inputs;
    };
  in
    mkFlake {
      hosts = builtins.mapAttrs mkHost {
        saturn.modules = [./hosts/saturn.nix];
        titan = {
          modules = [./hosts/titan.nix];
          deploy.hostname = "192.168.2.108";
        };
        neptune = {
          modules = [./hosts/neptune.nix];
          deploy.hostname = "78.47.87.53";
        };
        mars = {
          class = "darwin";
          modules = [./hosts/mars.nix];
        };
      };
      outputs = {
        formatter = pkgs: pkgs.nixpkgs-fmt;
        packages = import ./homeless;
        devShells = pkgs: {
          default = pkgs.mkShellNoCC {
            packages =
              pkgs.lib.attrsets.mapAttrsToList
              (name: value: value)
              inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
          };
        };
      };
    };
}
