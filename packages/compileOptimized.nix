{ lib, callPackage }:

let
  mkOverridablePackage = pkg: lib.makeOverridable (callPackage pkg {}) {};
in
{
  compileOptimized = rec {
    C = mkOverridablePackage ./compileOptimized/C.nix;
    CNoLTO = C.override { enableLTO = false; };
    Rust = mkOverridablePackage ./compileOptimized/Rust.nix;
  };
}
