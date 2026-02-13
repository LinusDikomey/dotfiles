{
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  libGL,
  egl-wayland,
  luajit,
  libspng,
  wayland,
  xwayland,
  wayland-scanner,
  libxcb,
  libxkbcommon,
  kdePackages,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "waywall";

  buildInputs = [
    meson
    libGL
    egl-wayland
    luajit
    libspng
    wayland
    xwayland
    wayland-scanner
    libxcb
    libxkbcommon
    kdePackages.wayland-protocols
    pkg-config
  ];
  nativeBuildInputs = [meson ninja];

  makeFlags = ["PREFIX=$(out)"];

  name = "waywall";

  installPhase = ''
    mkdir -p $out/bin
    install waywall/waywall $out/bin/
  '';

  src = fetchFromGitHub {
    rev = "5be432b5852b460823dabaf16e345255989c9ef8";
    owner = "tesselslate";
    repo = "waywall";
    hash = "sha256-uEV2RWIbLBNRuY+8ewX5V3Vnlyk3nRfjVT0SOoDD3VQ=";
  };
})
