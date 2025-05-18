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
    "--allow-import=github.com:443,jsr.io:443,cdn.jsdelivr.net:443,esm.sh:443,deno.land:443"
  ];
in
stdenv.mkDerivation rec {
  pname = "invidious-companion";
  version = "0-unstable-2025-05-12";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = pname;

    rev = "b5880aea9575bc950a9e0ee62f9a8cc5b6c049f8";
    hash = "sha256-sNt0ts2vI44yPgoai8agJQYzudqV3ESiOiTCgZC7nT4=";
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
