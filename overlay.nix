final: prev:

let
  stackpkgs = final.callPackage ./stackpkgs.nix;
in
builtins.removeAttrs stackpkgs [
  "vscode-extensions"
] // {
  vscode-extensions = prev.vscode-extensions // stackpkgs.vscode-extensions;
}
