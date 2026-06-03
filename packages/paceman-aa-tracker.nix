{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  temurin-bin-25,
  java ? temurin-bin-25,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "paceman-aa-tracker";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/PaceMan-MCSR/PaceMan-AA-Tracker/releases/download/v${finalAttrs.version}/paceman-aa-tracker-${finalAttrs.version}.jar";
    hash = "sha256-hHhOMoo8iyckmGBKOcN9fcZ6Cj1kiV87fSxmuZf8AVM=";
  };

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/paceman-aa-tracker/paceman-aa-tracker.jar

    makeWrapper ${lib.getExe java} $out/bin/paceman-aa-tracker \
        --add-flags "-jar $out/share/paceman-aa-tracker/paceman-aa-tracker.jar"

    runHook postInstall
  '';

  meta = {
    description = "Standalone application to track AA runs for PaceMan.gg";
    homepage = "https://github.com/PaceMan-MCSR/PaceMan-Tracker";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "paceman-aa-tracker";
  };
})
