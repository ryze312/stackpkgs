{ lib, crystal, invidious }:

let
  nixpkgsVersion = invidious.version;

  # Hack to override shards file
  crystalOverride = crystal // {
    buildCrystalPackage =
      args: crystal.buildCrystalPackage
        (args // { shardsFile = ./invidious/shards.nix; });
  };

  invidious-unstable = invidious.override {
    crystal = crystalOverride;
    versions = lib.importJSON ./invidious/versions.json;
  };
in

# Warn in case there is a newer version available,
# this means we need to update the commit.
# compareVersions returns 1 if left hand version is newer than the right hand version
lib.warnIf
      (builtins.compareVersions nixpkgsVersion "2.20250913.0" == 1)
      "New Invidious version (${nixpkgsVersion}), please check the changelog and update"

invidious-unstable.overrideAttrs {
  # No need for the patches, since we pull from master
  patches = [];
}
