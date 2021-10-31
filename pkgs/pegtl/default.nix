{ stdenv, lib, fetchFromGitHub, cmake, boost, ninja }:

stdenv.mkDerivation rec {
  pname = "pegtl";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = pname;
    rev = version;
    hash = sha256:1ngw7p4j08zb65pzqbayw1lpdmgnxn1k54fij74q0zq5x48mrhmi;
  };

  buildInputs = [ ninja cmake boost ];
  postInstall = ''
    pwd
    ls .
    ls $src
    cp $src/doc/*.md $out/share/doc/
    cp -r $src/src/example $out/share/doc/
  '';

  meta = with lib; {
    license = licenses.mit;
    description = "Parsing Expression Grammar Template Library";
    maintainer = maintainers.igsha;
  };
}
