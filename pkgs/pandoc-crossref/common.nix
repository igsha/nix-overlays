{ version, hash, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pandoc-crossref";
  inherit version;
  sourceRoot = "./";

  src = fetchurl {
    url = "https://github.com/lierdakil/${pname}/releases/download/v${version}/${pname}-Linux.tar.xz";
    inherit hash;
  };

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp pandoc-crossref $out/bin/
    cp pandoc-crossref.1 $out/share/man/man1/
  '';
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://lierdakil.github.io/pandoc-crossref;
    description = "Pandoc filter for cross-references";
    license = licenses.gpl2;
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
