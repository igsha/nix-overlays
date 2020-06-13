{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "cmake-format";
  version = "0.6.10";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    pname = "cmake_format";
    inherit version;
    hash = sha256:14ypplkjah4hcb1ad8978xip4vvzxy1nkysvyi1wn9b24cbfzw42;
  };

  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ jinja2 pyyaml six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/cheshirekow/cmake_format;
    license = licenses.gpl3;
    description = "Provides Quality Assurance (QA) tools for cmake";
  };
}
