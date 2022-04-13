{ appimageTools, fetchurl }:

appimageTools.wrapType2 {
  pname = "Netron";
  version = "5.7.0";
  src = fetchurl {
    url = https://github.com/lutzroeder/netron/releases/download/v5.7.0/Netron-5.7.0.AppImage;
    hash = "sha256-72qilYxqg2ihZvEwJNn9WeyMgGERMNMgoa+XQRgoP7M=";
  };
}
