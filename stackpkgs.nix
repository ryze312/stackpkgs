{ callPackage }:

{
  audiorelay = callPackage ./packages/audiorelay.nix {};
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  piped-backend = callPackage ./packages/piped-backend.nix {};
  piped-proxy = callPackage ./packages/piped-proxy.nix {};
  ultimatedoombuilder = callPackage ./packages/ultimatedoombuilder.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};
}
