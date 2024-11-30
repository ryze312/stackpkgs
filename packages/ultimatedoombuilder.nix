{
  stdenv,
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  mono,
  iconv,
  imagemagick,
  msbuild,
  alsa-lib,
  libGL,
  gtk2,
  xorg,
}:

let
  desktopItem = makeDesktopItem {
    name = "ultimate-doom-builder";

    desktopName = "Ultimate Doom Builder";
    genericName = "Map editor";
    categories = [ "Development" "Game" ];
    icon = "ultimate-doom-builder";
    exec = "ultimate-doom-builder";

    startupNotify = true;
    startupWMClass = "ultimate-doom-builder";
  };
in
stdenv.mkDerivation {
  pname = "UltimateDoomBuilder";
  version = "4207";

  src = fetchFromGitHub {
    owner = "UltimateDoomBuilder";
    repo = "UltimateDoomBuilder";

    # Have to use later commit because of missing DLLs
    # See https://github.com/UltimateDoomBuilder/UltimateDoomBuilder/commit/6a66d1ada4b47c1331413ea8c5755e275c594df2
    rev = "e7083ff00d2d9a2d33d5dbf610d15e2719b14f4b";
    hash = "sha256-DjLgyuPwT92q0QthwWLCSF+I9lTgHxHqsAwESyYT/xc=";
  };

  nativeBuildInputs = [
    makeWrapper
    iconv
    imagemagick
    msbuild
    libGL
  ] ++ (with xorg; [ libX11 libXfixes ]);

  # Some files contain wronly encoded files
  # Try to convert to UTF-8 to fix them
  # See https://github.com/UltimateDoomBuilder/UltimateDoomBuilder/issues/1092
  patchPhase = ''
    runHook prePatch

    fixEncoding() {
      cp "$1" temp
      iconv -f WINDOWS-1252 -t UTF8 temp -o "$1"
      rm temp
    }

    fixEncoding Source/Core/Controls/MultiSelectTreeview.cs
    fixEncoding Source/Core/Geometry/Vector2D.cs
    fixEncoding Source/Plugins/BuilderModes/ClassicModes/CurveLinedefsMode.cs

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/ultimate-doom-builder
    cp -r Build/* $out/opt/ultimate-doom-builder
    rm -f $out/opt/ultimate-doom-builder/Builder.sh

    convert "Source/Core/Resources/UDB2.ico[3]" icon.png

    install -Dm644 icon.png $out/share/pixmaps/ultimate-doom-builder.png
    install -Dm644  ${desktopItem}/share/applications/ultimate-doom-builder.desktop $out/share/applications/ultimate-doom-builder.desktop

    makeWrapper ${lib.getExe' mono "mono"} $out/bin/ultimate-doom-builder \
      --add-flags $out/opt/ultimate-doom-builder/Builder.exe \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ alsa-lib libGL gtk2 ]}

    runHook postInstall
  '';

  meta = {
    description = "Comprehensive map editor for Doom, Heretic, Hexen and Strife based games";
    homepage = "https://github.com/UltimateDoomBuilder/UltimateDoomBuilder";
    downloadPage = "https://ultimatedoombuilder.github.io";
    license = lib.licenses.gpl3;
  };
}
