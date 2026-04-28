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
  lib,
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

  meta.platforms = lib.platforms.linux;

  src = fetchFromGitHub {
    rev = "783ef2f4a4c59240d0b4570e126466d9ccd675ae";
    owner = "tesselslate";
    repo = "waywall";
    hash = "sha256-KZMg/6ab1xEzUFcO/glQaf/3/1gkO23s4pp2wuCGUjM=";
  };
})
