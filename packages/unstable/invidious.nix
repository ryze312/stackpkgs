{ lib, invidious }:

let
  version = invidious.version;
  invidious-unstable = invidious.override {
    versions = lib.importJSON ./invidious/versions.json;
  };
in

# Don't build in case there is a newer version available.
# This means we need to update commit or just use the nixpkgs provided version
# compareVersions returns 1 if left hand version is newer than the right hand version
assert lib.assertMsg
      (builtins.compareVersions version "2.20250517.0" != 1)
      "New Invidious version (${version}), please check changelog and update";

invidious-unstable.overrideAttrs {
  # No need for the patches, since we pull from master
  patches = [];
}
