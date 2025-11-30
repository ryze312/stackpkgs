{
  lib,
  buildPythonPackage,
  fetchPypi,

  hatchling,
  hatch-vcs,

  typing-extensions,
  beartype,
  rich,
 }:

buildPythonPackage rec {
  pname = "plum-dispatch";
  version = "2.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;

    pname = "plum_dispatch";
    hash = "sha256-CTZxNFQaBfll4/WMGR9PRbke8dh2E4NRcXkGF7uHzm0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    typing-extensions
    beartype
    rich
  ];

  meta = {
    description = "Multiple Dispatch in Python";
    homepage = "https://github.com/beartype/plum";
    license = lib.licenses.mit;
  };
}
