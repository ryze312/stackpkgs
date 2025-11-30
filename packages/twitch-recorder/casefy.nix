{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "casefy";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hJ1uD4BQb6xwq44YmZpMoet9j3CUFoI4PWSqIqdJf48=";
  };

  build-system = [ hatchling ];

  meta = {
    description = "Lightweight Python package to convert the casing of strings";
    homepage = "https://github.com/dmlls/python-casefy";
    license = lib.licenses.mit;
  };
}
