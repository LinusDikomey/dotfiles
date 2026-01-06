{
  lib,
  pkgs,
  ...
}: {
  xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    defaultApplications = let
      browser = "helium.desktop";
    in {
      "image/png" = browser;
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "application/pdf" = browser;
      "inode/directory" = "org.gnome.Nautilus.desktop";
    };
  };
}
