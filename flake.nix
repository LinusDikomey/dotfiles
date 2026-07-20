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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      # TODO: change this back after associated PR is merged: https://github.com/sodiboo/niri-flake/pull/1850
      url = "github:sodiboo/niri-flake?rev=6bb99ff875919f03ea6054026619d999061e1170";
      # url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eye = {
      url = "github:LinusDikomey/eye";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    waldbot = {
      url = "github:LinusDikomey/waldbot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcsr = {
      url = "https://git.uku3lig.net/uku/mcsr-nixos/archive/main.tar.gz";
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
      outputs = let
        packagesCommon = pkgs: rec {
          callHomelessWith = keymap:
            rec {
              callHomeless = let
                values = import ./modules/theme/values.nix pkgs;
              in
                path:
                  import path {
                    inherit pkgs callHomeless inputs;
                    config.dotfiles = {
                      inherit (values) theme;
                      keymap = import keymap;
                    };
                  };
            }.callHomeless;
          filterCompatible = pkgs.lib.filterAttrs (
            _: p: pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform p
          );
          localPkgs = filterCompatible (pkgs.lib.mapAttrs (_: p: pkgs.callPackage p {}) (import ./packages));
          homelessWith = keymap: filterCompatible (import ./homeless (callHomelessWith keymap));
          colemak-dh = homelessWith ./modules/home/keymap/colemak_dh.nix;
          qwerty = homelessWith ./modules/home/keymap/qwerty.nix;
        };
      in {
        formatter = {pkgs, ...}: pkgs.nixpkgs-fmt;
        packages = {pkgs, ...}: let
          common = packagesCommon pkgs;
        in
          common.localPkgs
          // common.colemak-dh
          // (pkgs.lib.mapAttrs' (name: value: pkgs.lib.nameValuePair (name + "-qwerty") value) common.qwerty);
        devShells = {
          pkgs,
          inputs',
          ...
        }: let
          common = packagesCommon pkgs;
          homePkgs = import ./modules/home/packages.nix {
            inherit pkgs inputs';
            config.dotfiles.coding.enable = true;
          };
        in {
          default = inputs.self.devShells.${pkgs.stdenv.hostPlatform.system}.colemak-dh;
          colemak-dh = pkgs.mkShellNoCC {packages = builtins.attrValues common.colemak-dh ++ homePkgs;};
          qwerty = pkgs.mkShellNoCC {packages = builtins.attrValues common.qwerty ++ homePkgs;};
        };
      };
    };
}
