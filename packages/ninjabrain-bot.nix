{
  stdenv,
  jre,
  makeWrapper,
  fetchurl,
  libxkbcommon,
  libxcb,
  libx11,
  libxt,
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
    libxcb
    libx11
    libxt
  ];
  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/Ninjabrain-Bot \
      --add-flags "-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel -jar $out/share/java/${name}-${version}.jar" \
      --set LD_LIBRARY_PATH "${libxkbcommon}/lib:${libxcb}/lib:${libx11}/lib:${libxt}/lib:$LD_LIBRARY_PATH"
  '';
}
