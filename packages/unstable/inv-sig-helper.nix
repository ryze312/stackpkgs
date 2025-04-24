{
  lib,
  inv-sig-helper,
}:

let
  version = inv-sig-helper.version;
in

# Don't build in case there is a newer version available.
# This means we need to update commit or just use the nixpkgs provided version
assert lib.assertMsg
      (!(lib.strings.versionOlder version "0-unstable-2025-04-03"))
      "New inv_sig-helper version (${version}), please check changelog and update";

inv-sig-helper
