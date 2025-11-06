{
  inputs,
  lib ? inputs.nixpkgs.lib,
}: systems: let
  getWithType = type: builtins.mapAttrs (name: value: value.value) (lib.filterAttrs (name: value: value.type == type) systems);
in {
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
  }) (lib.filterAttrs (_: value: value.deploy != null) systems);
  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
}
