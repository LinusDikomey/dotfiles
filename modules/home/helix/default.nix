{
  pkgs,
  callHomeless,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = callHomeless ./settings.nix;
    languages = callHomeless ./languages.nix;
  };
  home.file = let
    treeSitterEye = pkgs.fetchFromGitHub {
      owner = "LinusDikomey";
      repo = "tree-sitter-eye";
      rev = "96eea2d00bbb4ed06fa29d22f7f508124abe01bc";
      sha256 = "sha256-K14lGWjIztdBuM/kgoWXTSVn1tKzKrAqX3l91cqM/Ak=";
    };
  in {
    ".config/helix/runtime/queries/eye/locals.scm".source = "${treeSitterEye}/queries/locals.scm";
    ".config/helix/runtime/queries/eye/highlights.scm".source = "${treeSitterEye}/queries/highlights.scm";
  };
}
