{ callPackage, invidious, inv-sig-helper }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  ultimatedoombuilder = callPackage ./packages/ultimatedoombuilder.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};

  unstable = {
    invidious = callPackage ./packages/unstable/invidious.nix { inherit invidious; };
    inv-sig-helper = callPackage ./packages/unstable/inv-sig-helper.nix { inherit inv-sig-helper; };
  };
}
