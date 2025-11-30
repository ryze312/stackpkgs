{ callPackage, invidious }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  twitch-recorder = callPackage ./packages/twitch-recorder.nix {};
  ultimatedoombuilder = callPackage ./packages/ultimatedoombuilder.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};

  unstable = {
    invidious = callPackage ./packages/unstable/invidious.nix { inherit invidious; };
    invidious-companion = callPackage ./packages/unstable/invidious-companion.nix {};
  };
}
