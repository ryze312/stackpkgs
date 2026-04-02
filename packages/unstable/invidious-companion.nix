{
  stdenv,
  lib,
  fetchFromGitHub,
  deno,

  makeWrapper,
}:

let
  date = "2026.03.22";
  rev = "cb8d9bbbb376242ccd7ccc4f30ab5037f732da2f";

  dateVersion = lib.replaceString "." "-" date;
  revAbbrev = lib.substring 0 7 rev;

  # Taken from deno.json
  denoArgs = lib.escapeShellArgs [
    "--allow-env"
    "--allow-net"
    "--allow-read=.,/var/tmp/youtubei.js,/tmp/invidious-companion.sock"
    "--allow-write=/var/tmp/youtubei.js,/tmp/invidious-companion.sock"
    "--allow-sys=hostname"
    "--allow-import=github.com:443,jsr.io:443,cdn.jsdelivr.net:443,esm.sh:443,deno.land:443"
  ];

  companionArgs = lib.escapeShellArgs [
    "--_version_date=${date}"
    "--_version_commit=${revAbbrev}"
  ];
in
stdenv.mkDerivation rec {
  pname = "invidious-companion";
  version = "0-unstable-${dateVersion}";

  src = fetchFromGitHub {
    inherit rev;

    owner = "iv-org";
    repo = pname;

    hash = "sha256-VPmkOYxwqrDcY25Au9vGuYgOc7C2BfLgGJGDK04lX6E=";
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
      --add-flags "${denoArgs}" \
      --add-flags src/main.ts \
      --add-flags "${companionArgs}"

    runHook postInstall
  '';

  meta = {
    description = "Invidious companion for handling video streams";
    homepage = "https://github.com/iv-org/invidious-companion";
    license = lib.licenses.agpl3Only;
    mainProgram = "invidious-companion";
  };
}
