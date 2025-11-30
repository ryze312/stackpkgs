{
  lib,
  buildPythonPackage,
  fetchPypi,

  poetry-core,
  poetry-dynamic-versioning,

  typing-inspect,
  typing-extensions,
  casefy,
  jinja2,
  plum-dispatch,
  beartype,

  tomli-w,
 }:

let
  # We have to use the older version of typing-extensions
  # as pyserde requires version < 4.14
  typing-extensions-old = typing-extensions.overrideAttrs (super: _: rec {
    name = "${super.pname}-${version}";
    version = "4.12.2";

    src = fetchPypi {
      inherit version;

      pname = "typing_extensions";
      hash = "sha256-Gn6tVcflWd1N7ohW46iLQSJav+HOjfV7fBORX+Eh/7g=";
    };
  });

  # Override for dependencies that transitively include typing-extensions
  override-ext = package: package.override {
    typing-extensions = typing-extensions-old;
  };

  typing-inspect-old = override-ext typing-inspect;
  beartype-old = override-ext beartype;

  plum-old = plum-dispatch.override {
    beartype = beartype-old;
    typing-extensions = typing-extensions-old;
  };
in
buildPythonPackage rec {
  pname = "pyserde";
  version = "0.25.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MCpTTpHVSKdHIr/hV39JftP9h3kKyb1FA5hSeWIuDNA=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    casefy
    jinja2

    # Optional TOML support
    tomli-w

    typing-inspect-old
    plum-old
    beartype-old
    typing-extensions-old
  ];

  meta = {
    description = "Yet another serialization library on top of dataclasses, inspired by serde-rs";
    homepage = "https://github.com/yukinarit/pyserde";
    license = lib.licenses.mit;
  };
}
