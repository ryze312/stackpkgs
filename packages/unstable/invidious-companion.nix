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
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = pname;

    rev = "f9f89a2192a0772d33e5e2ceec3586f169b42996";
    hash = "sha256-cnMk7HCGzvQ8AosheETR+6XfLnk2tOffKOs+sKZZ1HM=";
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
