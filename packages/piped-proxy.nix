{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "piped-proxy";
  version = "unstable-2024-09-30";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped-proxy";

    rev = "7172ff43d3222329ba0d178c96be204b6b6359f6";
    hash = "sha256-kKwC+baeD6NwMQoFgyMJiwCKAOhgVG6hnPbEHkV4qp0=";
  };

  cargoHash = "sha256-2evO15Au4tPWZH5KJh6ix8vtLtorzWXlmga24wgXxgo=";

  meta = {
    description = "Proxy for Piped written in Rust";
    homepage = "https://github.com/TeamPiped/Piped-Proxy";
    license = lib.licenses.agpl3Only;
  };
}
