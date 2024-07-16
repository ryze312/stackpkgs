{ callPackage }:

{
  compileOptimized = callPackage ./packages/compileOptimized.nix {};
  vscode-extensions = callPackage ./packages/vscode-extensions.nix {};
}
