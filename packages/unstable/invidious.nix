{ lib, invidious }:

let
  invidious-unstable = invidious.override {
    versions = lib.importJSON ./invidious/versions.json;
  };
in
invidious-unstable.overrideAttrs {
  # No need for the patches, since we pull from master    
  patches = [];
}
