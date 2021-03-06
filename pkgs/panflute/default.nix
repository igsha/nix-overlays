{ stdenv, lib, python3Packages }:

let
  shutilwhich = python3Packages.buildPythonPackage rec {
      pname = "shutilwhich";
      version = "1.1.0";
      name = "${pname}-${version}";
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "db1f39c6461e42f630fa617bb8c79090f7711c9ca493e615e43d0610ecb64dc6";
      };
      doCheck = false;
      meta = with lib; {
        homepage = "";
        license = "PSF";
        description = "shutil.which for those not using Python 3.3 yet.";
      };
    };

in python3Packages.buildPythonPackage rec {
  pname = "panflute";
  version = "1.10.6";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "f4f810487b220c5441c86c7a16165d65e0da25c670c204255977e52addbaebc3";
  };

  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ pandocfilters lxml pyyaml future shutilwhich ];

  meta = with lib; {
    homepage = http://scorreia.com/software/panflute;
    license = licenses.bsdOriginal;
    description = "Pythonic Pandoc filters";
  };
}
