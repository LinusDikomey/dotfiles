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
    rev = "6f70bec29eb0eba16df12ae5a3a1e89b0c5b1b2c";
    sha256 = "sha256-TTm5tDNQiSOkD6IVHDQ7udsYp01N3ee0m7lBRPfp9SM=";
  };

  postPatch = ''
    mv resources/gui/Advancely_Logo_NoText.png resources/gui/Advancely_Logo_NoText_512_Linux.png
  '';
  postInstall = ''
    substituteInPlace $out/bin/advancely \
      --replace-fail '/usr/share/advancely' "$out/share/advancely"
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
