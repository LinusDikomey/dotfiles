{
  stdenv,
  jre,
  makeWrapper,
  fetchurl,
  libxkbcommon,
  xorg,
}:
stdenv.mkDerivation rec {
  name = "Ninjabrain-Bot";
  version = "1.5.1";
  src = fetchurl {
    url = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/download/1.5.1/Ninjabrain-Bot-1.5.1.jar";
    sha256 = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };
  dontUnpack = true;

  nativeBuildInputs = [makeWrapper];
  buildInputs = [
    libxkbcommon
    xorg.libxcb
    xorg.libX11
    xorg.libXt
  ];
  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/Ninjabrain-Bot \
      --add-flags "-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel -jar $out/share/java/${name}-${version}.jar" \
      --set LD_LIBRARY_PATH "${libxkbcommon}/lib:${xorg.libxcb}/lib:${xorg.libX11}/lib:${xorg.libXt}/lib:$LD_LIBRARY_PATH"
  '';
}
