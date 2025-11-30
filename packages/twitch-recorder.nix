{
  lib,
  python313Packages,
  fetchFromGitea,
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

  # Replace with fetchPyPI
  src = fetchFromGitea {
    domain = "code.thishorsie.rocks";
    owner = "ryze";
    repo = pname;
    rev = "52719593721a8d5d9fc344e9f1ac66f70dc63923";
    hash = "sha256-doakSR/mgbz7cGycdWR4XJ8nxX5KnOY2nfsx+kOjMQY=";
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
