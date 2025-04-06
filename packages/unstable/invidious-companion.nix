{
  stdenv,
  lib,
  fetchFromGitHub,
  deno,

  makeWrapper,
}:

let
  # Taken from deno.json
  denoArgs = [
    "--allow-env"
    "--allow-net"
    "--allow-read"
    "--allow-write=/var/tmp/youtubei.js"
    "--allow-sys=hostname"
    "--allow-import=github.com:443,jsr.io:443,raw.githubusercontent.com:443,esm.sh:443,deno.land:443"
  ];
in
stdenv.mkDerivation rec {
  pname = "invidious-companion";
  version = "0-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = pname;

    # Latest version that works
    # See https://github.com/iv-org/invidious-companion/issues/80
    rev = "26cb520e15b8bd3b0ce03233353877a372a9b9ab";
    hash = "sha256-Bg3eQmKH7YB/F02TR7Ki1eH01CDKLM1aa3fp+peolUA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    mv src deno.json deno.lock $out/share/${pname}

    makeWrapper ${deno}/bin/deno $out/bin/invidious-companion \
      --chdir $out/share/${pname} \
      --add-flags run \
      --add-flags "${lib.escapeShellArgs denoArgs}" \
      --add-flags src/main.ts

    runHook postInstall
  '';

  meta = {
    description = "Invidious companion for handling video streams";
    homepage = "https://github.com/iv-org/invidious-companion";
    license = lib.licenses.agpl3Only;
    mainProgram = "invidious-companion";
  };
}
