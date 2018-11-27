{ stdenv, pythonPackages, panflute, fetchFromGitHub }:

pythonPackages.buildPythonPackage rec {
  pname = "pantable";
  version = "0.11.1";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "ae1eb735a60fc3b6a2f763883d8891829760dc5a48eef8ddfebf6b6d748133b7";
  };

  doCheck = false;
  propagatedBuildInputs = [ panflute ];

  meta = with stdenv.lib; {
    homepage = https://ickc.github.io/pantable;
    license = licenses.gpl3;
    description = "Pandoc Filter for CSV Tables";
  };
}
