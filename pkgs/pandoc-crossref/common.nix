{ version, sha256, pandocVersion, stdenv, fetchurl }:

let
  selfVersion = version;
  selfSha256 = sha256;

in stdenv.mkDerivation rec {
  pname = "pandoc-crossref";
  version = selfVersion;
  sourceRoot = "./";

  src = fetchurl {
    url = "https://github.com/lierdakil/pandoc-crossref/releases/download/v${version}/linux-pandoc_${pandocVersion}.tar.gz";
    sha256 = selfSha256;
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp pandoc-crossref $out/bin/
    cp pandoc-crossref.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    homepage = https://lierdakil.github.io/pandoc-crossref;
    description = "Pandoc filter for cross-references";
    license = licenses.gpl2;
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
