{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,
  wheel,

  aiohttp
 }:

buildPythonPackage rec {
  pname = "twitchio";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KxysnoV7xSTLlHxShOcEcooFYbNy8awXD13hcU6PjVY=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ aiohttp ];

  meta = {
    description = "Fully featured, powerful async Python library for the Twitch API and EventSub";
    homepage = "https://github.com/PythonistaGuild/TwitchIO";
    license = lib.licenses.mit;
  };
}
