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
  xorg,
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
    xorg.libxcb
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
    rev = "5e22624";
    owner = "tesselslate";
    repo = "waywall";
    hash = "sha256-th92YAUAprFTTEMpKtnjBGc2CDuL3cuhg8rDmHVF4nY=";
  };
})
