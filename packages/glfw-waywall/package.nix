{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libXrandr,
  libXinerama,
  libXcursor,
  libX11,
  libXi,
  libXext,
  libXxf86vm,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glfw-waywall";
  name = "glfw-waywall";

  src = fetchFromGitHub {
    rev = "e7ea71b";
    owner = "glfw";
    repo = "glfw";
    hash = "sha256-Jp4aCDv47g/ZpUGI2lBTykrOwkZKAnZ2qQkcfTaTNO8=";
  };

  patches = [./glfw.patch];

  propagatedBuildInputs = [libGL];

  nativeBuildInputs = [cmake pkg-config wayland-scanner];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libXxf86vm
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DGLFW_BUILD_WAYLAND=ON"
  ];
  #makeFlags = ["PREFIX=$(out)"];
})
