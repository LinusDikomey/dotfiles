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
    rev = "26242bd654f1db295808c6e4d8315d2e2124ea6e";
    owner = "tesselslate";
    repo = "waywall";
    hash = "sha256-SlT7B01sAKE3n9HVnE+t9hcbQnr5qcCBsBAy4btN0mw=";
  };
})
