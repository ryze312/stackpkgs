{ callPackage }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  ultimatedoombuilder = callPackage ./packages/ultimatedoombuilder.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};

  unstable = {
    invidious = callPackage ./packages/unstable/invidious.nix {};
    inv-sig-helper = callPackage ./packages/unstable/inv-sig-helper.nix {};
  };
}
