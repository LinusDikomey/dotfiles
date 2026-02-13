{
  stdenv,
  fetchFromGitHub,
  cmake,
  harfbuzz,
  pkg-config,
  sdl3,
  sdl3-image,
  sdl3-ttf,
  curl,
}:
stdenv.mkDerivation {
  pname = "advancely";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "LNXSeus";
    repo = "Advancely";
    rev = "aa91934454ba2f349643f5f0244629952d39afe4";
    sha256 = "sha256-50vxr8bYWpBHDBKmwlzWO/ystj1xOB1dfuhlDXoBmUo=";
  };

  postPatch = ''
    mv resources/gui/Advancely_Logo_NoText.png resources/gui/Advancely_Logo_NoText_512_Linux.png
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    sdl3
    sdl3-image
    sdl3-ttf
    curl
  ];

  buildInputs = [
    harfbuzz
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    # "-DBUILD_TESTS=OFF"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cmake --install . --prefix $out
    runHook postInstall
  '';
}
