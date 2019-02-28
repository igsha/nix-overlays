{ version, sha256, stdenv, fetchurl }:

let
  pandocVersion = version;
  pandocSha256 = sha256;

in stdenv.mkDerivation rec {
  pname = "pandoc";
  version = pandocVersion;

  src = fetchurl {
    url = "https://github.com/jgm/pandoc/releases/download/${version}/${pname}-${version}-linux.tar.gz";
    sha256 = pandocSha256;
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jgm/pandoc;
    description = "Release package for universal markup converter";
    license = licenses.gpl2;
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
