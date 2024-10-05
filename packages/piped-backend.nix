{
  stdenv,
  lib,
  stackpkgs,
  fetchFromGitHub,
  gradle,
  stripJavaArchivesHook,
  makeWrapper,
  semeru-jre-bin-21,
  javaRuntime ? semeru-jre-bin-21
}:

stdenv.mkDerivation {
  pname = "piped-backend";
  version = "unstable-2024-07-27";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped-Backend";

    rev = "01e2cf1456eb8d88d0057828d658ef33d49bd2bc";
    hash = "sha256-8s9Xng+7y92cJ8YUrmhY77tQ89Nzw900AVmOdCkXjag=";
  };

  nativeBuildInputs = [
    gradle
    stripJavaArchivesHook
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    pkg = stackpkgs.piped-backend;
    data = ./piped-backend/deps.json;
  };

  gradleBuildTask = "shadowJar";
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preBuild

    install -Dm644 build/libs/piped-1.0-all.jar $out/share/piped-backend.jar
    makeWrapper ${javaRuntime}/bin/java $out/bin/piped-backend \
      --add-flags "-jar $out/share/piped-backend.jar"

    runHook postBuild
  '';

  meta = {
    description = "Core component behind Piped, and other alternative frontends";
    homepage = "https://github.com/TeamPiped/Piped-Backend";
    license = lib.licenses.agpl3Only;

    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm-cache
      binaryNativeCode # reqwest4j
    ];
  };
}
