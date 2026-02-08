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
    rev = "fe88c9dd3cd31906dede677ac01dc9de8ab6f0eb";
    sha256 = "sha256-+DUkh0GUkeoG8sAwgS5RzG9vHYGiGdfgLT+B6A4bmhg=";
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
