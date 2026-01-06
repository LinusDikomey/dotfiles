{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}: let
  pname = "helium";
  version = "0.7.10.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-11xSlHIqmyyVwjjwt5FmLhp72P3m07PppOo7a9DbTcE=";
    };
  };

  src = let
    inherit (architectures.${stdenv.hostPlatform.system}) arch hash;
  in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
      inherit hash;
    };
in let
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraInstallCommands = ''
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/helium.png $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
    meta = {
      platforms = lib.attrNames architectures;
    };
  }
