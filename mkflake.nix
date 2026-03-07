{
  inputs,
  lib ? inputs.nixpkgs.lib,
}: {
  hosts,
  outputs ? {},
  supportedSystems ? lib.systems.flakeExposed,
}: let
  getWithType = type: builtins.mapAttrs (name: value: value.value) (lib.filterAttrs (name: value: value.type == type) hosts);
  forAllSystems = lib.genAttrs supportedSystems;
in
  {
    nixosConfigurations = getWithType "nixos";
    darwinConfigurations = getWithType "darwin";
    deploy.nodes = lib.mapAttrs (name: value: {
      hostname = value.deploy.hostname;
      profiles.system = {
        sshUser = "root";
        path = let
          pkgs = import inputs.nixpkgs {system = value.system;};
          deployPkgs = import inputs.nixpkgs {
            system = value.system;
            overlays = [
              inputs.deploy-rs.overlays.default
              (self: super: {
                deploy-rs = {
                  inherit (pkgs) deploy-rs;
                  lib = super.deploy-rs.lib;
                };
              })
            ];
          };
        in
          deployPkgs.deploy-rs.lib.activate.${value.class} inputs.self."${value.class}Configurations".${name};
      };
    }) (lib.filterAttrs (_: value: value.deploy != null) hosts);
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
  }
  // builtins.mapAttrs (name: f:
    forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in
      f pkgs))
  outputs
