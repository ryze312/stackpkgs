{ callPackage }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};
}
