{
  description = "Collection of packages and overlays used by me";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    overlay = import ./overlay.nix;

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlay ];
    };
  in
  {
    packages.${system} = pkgs.callPackage ./stackpkgs.nix {};
    overlays.default = overlay;
  };
}
