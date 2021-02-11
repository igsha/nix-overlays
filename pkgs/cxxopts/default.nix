{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "cxxopts";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = name;
    rev = "v${version}";
    sha256 = "1l0bm0ysqa7j7kqhfi4mk6k4rhh5xc6mx82lw468sccn8m8a4ppg";
  };

  buildInputs = [ cmake ];

  meta = with lib; {
    license = licenses.mit;
    description = "Lightweight C++ command line option parser";
    maintainer = maintainers.igsha;
  };
}
