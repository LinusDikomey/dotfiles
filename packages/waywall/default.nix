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
    rev = "799f2b0855ebabf18d58182db0470f8eee54388a";
    owner = "tesselslate";
    repo = "waywall";
    hash = "sha256-k9sGUZJomt/nF9bERCwTRnOz1nrqMiN5BjEeZEWS+b0=";
  };
})
