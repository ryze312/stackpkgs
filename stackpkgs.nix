{ callPackage }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  ultimatedoombuilder = callPackage ./packages/ultimatedoombuilder.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};
}
