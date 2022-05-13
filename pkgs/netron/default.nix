{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "Netron";
  version = "5.7.8";
  src = fetchurl {
    url = "https://github.com/lutzroeder/netron/releases/download/v${version}/${pname}-${version}.AppImage";
    hash = "sha256-2u0lem9umMKot/OSYcVNrilD1osd+CoZp9pLhKVO/OE=";
  };
}
