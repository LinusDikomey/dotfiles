{
  inputs ? throw "No inputs provided",
  lib ? inputs.nixpkgs.lib,
  users,
  defaultUser ? null,
  nixpkgs-stable ? throw "nixpkgs-stable not provided to mksystem.nix",
}: name: {
  modules ? [],
  specialArgs ? {},
  class ? "nixos",
  user ? defaultUser,
  homeFolder ?
    if class == "darwin"
    then "Users"
    else "home",
  deploy ? null,
}: let
  nixpkgs = inputs.nixpkgs or (throw "No nixpkgs input found");
  nix-darwin = inputs.nix-darwin or (throw "Nox nix-darwin input found");

  modulesPath =
    if class == "nixos"
    then "${nixpkgs}/nixos/modules"
    else if class == "darwin"
    then "${nix-darwin}/modules"
    else throw "Invalid class provided";
  baseModules = import "${modulesPath}/module-list.nix";
  dotfiles = {
    inherit homeFolder users;
    username = user;
    user = users.${user};
    wallpaper = ./wallpaper.png;
  };
  commonSpecialArgs = {
    inherit inputs dotfiles;
  };
  eval = lib.evalModules {
    inherit class;

    specialArgs = commonSpecialArgs // {inherit modulesPath;} // specialArgs;
    modules = let
      modulesName = "${class}Modules";
    in
      baseModules
      ++ modules
      ++ [
        ./modules
        inputs.home-manager.${modulesName}.default
        inputs.agenix.${modulesName}.default
        ({config, ...}: {
          config = let
            extraSpecialArgs = {
              inputs' = lib.mapAttrs (_: lib.mapAttrs (_: v: v.${config.nixpkgs.hostPlatform.system} or v)) inputs;
              pkgs-stable = import nixpkgs-stable {
                system = config.nixpkgs.hostPlatform.system;
                config = config.nixpkgs.config;
              };
            };
          in {
            _module.args =
              extraSpecialArgs
              // {
                inherit baseModules modules;
              };

            home-manager = {
              extraSpecialArgs = commonSpecialArgs // extraSpecialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
            };

            networking.hostName = name;
            nixpkgs.flake.source = inputs.nixpkgs.outPath;
            nixpkgs.config.allowUnfree = true;
          };
        })
      ]
      ++ lib.optionals (class == "nixos") [
        ./modules/nixos
      ]
      ++ lib.optionals (class == "darwin") [
        ./modules/darwin
        {
          config = {
            nixpkgs.source = nixpkgs.outPath;

            system = {
              checks.verifyNixPath = false;

              darwinVersionSuffix = ".${nix-darwin.shortRev or nix-darwin.dirtyShortRev or "dirty"}";
              darwinRevision = nix-darwin.rev or nix-darwin.dirtyRev or "dirty";
            };
          };
        }
      ];
  };
  system = eval.config.system.build.toplevel;
in
  (
    if class == "darwin"
    then {
      type = "darwin";
      value = eval // {inherit system;};
    }
    else {
      type = "nixos";
      value = eval;
    }
  )
  // {
    inherit class deploy;
    system = eval.config.nixpkgs.hostPlatform.system;
  }
