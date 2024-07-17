{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  temurin-bin-17,
  zip,

  libglvnd,
  alsa-lib,
  libpulseaudio
}:

let
  manifest = ''
    Manifest-Version: 1.0
    Main-Class: com.azefsw.audioconnect.desktop.app.MainKt
    Specification-Title: Java Platform API Specification
    Specification-Version: 17
    Specification-Vendor: Oracle Corporation
    Implementation-Title: Java Runtime Environment
    Implementation-Version: 17.0.6
    Implementation-Vendor: Eclipse Adoptium
    Created-By: 17.0.5 (Eclipse Adoptium)
  '';

  runtimeLibs = [
    libglvnd
    alsa-lib
    libpulseaudio
    stdenv.cc.cc.lib
  ];
in

stdenv.mkDerivation {
  pname = "audiorelay";
  version = "0.27.5";

  src = fetchzip {
    url = "https://dl.audiorelay.net/setups/linux/audiorelay-0.27.5.tar.gz";
    hash = "sha256-KfhAimDIkwYYUbEcgrhvN5DGHg8DpAHfGkibN1Ny4II=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    zip
  ];

  # Patch the jar with manifest with main class to use it unwrapped
  patchPhase = ''
    mkdir META-INF

    echo '${manifest}' > META-INF/MANIFEST.MF
    zip -r lib/app/audiorelay.jar META-INF/MANIFEST.MF
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib/app/audiorelay.jar $out/lib

    # Can't use from pkgs since these ones are older and newer fails to load some symbols
    cp lib/runtime/lib/libnative-rtaudio.so $out/lib
    cp lib/runtime/lib/libnative-opus.so $out/lib

    makeWrapper ${temurin-bin-17}/bin/java $out/bin/audiorelay \
      --add-flags "-jar $out/lib/audiorelay.jar" \
      --prefix LD_LIBRARY_PATH : $out/lib/ \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}

    runHook postInstall
  '';

}
