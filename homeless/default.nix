pkgs: let
  values = import ../modules/theme/values.nix pkgs;
  callHomeless = path:
    import path values;
  importHomeless = path: import path {inherit pkgs callHomeless;};
in {
  helix = importHomeless ./helix.nix;
}
