final: prev:

let
  stackpkgs = prev.callPackage ./stackpkgs.nix {
     inherit (prev) invidious;
  };
in
{
  stackpkgs = builtins.removeAttrs stackpkgs [
    "vscode-extensions"
  ];
} // {
  vscode-extensions = prev.vscode-extensions // stackpkgs.vscode-extensions;
}
