{
  description = "Collection of packages and overlays";

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
    nixosModules = import ./modules.nix;
    overlays.default = overlay;
  };
}
