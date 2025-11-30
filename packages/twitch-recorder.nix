{
  lib,
  python313Packages,
  fetchPypi,
  ffmpeg-headless,
}:

let
  buildLib = name: deps: python313Packages.callPackage ./twitch-recorder/${name}.nix deps;

  casefy = buildLib "casefy" {};
  plum-dispatch = buildLib "plum-dispatch" {};

  twitchio = buildLib "twitchio" {};
  pyserde = buildLib "pyserde" {
    inherit casefy plum-dispatch;
  };

  ffmpegPath = lib.makeBinPath [ ffmpeg-headless ];
in
python313Packages.buildPythonApplication rec {
  pname = "twitch-recorder";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "twitch_recorder";
    hash = "sha256-/CBKDmgtjw42LPz9/lrjHSWip7Wt/QC5h8O+t/wrB0o=";
  };

  build-system = with python313Packages; [
    uv-build
  ];

  dependencies = with python313Packages; [
    yt-dlp
  ]
  ++ [
    twitchio
    pyserde
  ];

  # Ensure ffmpeg is available at runtime as yt-dlp needs it to download streams
  makeWrapperArgs = [
    "--prefix PATH : \"${ffmpegPath}\""
  ];

  meta = {
    description = "Twitch application for automatically downloading streams";
    homepage = "https://code.thishorsie.rocks/ryze/twitch-recorder";
    license = lib.licenses.agpl3Only;
    mainProgram = "twitch-recorder";
  };
}
