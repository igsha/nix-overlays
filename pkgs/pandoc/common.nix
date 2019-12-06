{ version, hash, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pandoc";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jgm/pandoc/releases/download/${version}/${pname}-${version}-linux-amd64.tar.gz";
    inherit hash;
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jgm/pandoc;
    description = "Release package for universal markup converter";
    license = licenses.gpl2;
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
