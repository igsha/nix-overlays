{ stdenv, lib, fetchurl, dpkg, patchelf, curl, freetype, libidn, gcc, alsaLib, glib, glibc,
libpulseaudio, libv4l, boost16x, libudev, gnupg, cppdb, speex, speexdsp, icu66, zeromq,
protobuf3_6, xorg, qt5, libGL, openssl, dbus, makeWrapper
}:

let
  libidn11 = libidn.overrideAttrs (old: rec {
    name = "libidn-1.34";
    src = fetchurl {
      url = "mirror://gnu/libidn/${name}.tar.gz";
      hash = sha256:0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p;
    };
  });
  protobuf = protobuf3_6;
  icu = icu66;

in stdenv.mkDerivation rec {
  pname = "trueconf";
  version = "7.5.2.127";

  src = fetchurl {
    url = https://trueconf.ru/download/trueconf_client_ubuntu2004_amd64.deb?v=202006231500;
    hash = sha256:1mpmrgzr7cgkx8az7mx6h354f7nci4p8l9yivfb6kbp80ghwgc43;
  };

  buildInputs = [ boost16x ];
  nativeBuildInputs = [ dpkg patchelf qt5.wrapQtAppsHook makeWrapper ];
  propagatedNativeBuildInputs = [
    stdenv.cc.cc
    glib
    glibc
    curl
    alsaLib
    libpulseaudio
    libv4l
    libudev
    freetype
    libidn11
    openssl
    dbus

    gnupg
    speex
    speexdsp
    zeromq
    cppdb
    icu
    protobuf

    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcb

    qt5.qtbase
    qt5.qtwebengine
    libGL
  ];
  libsPath = lib.makeLibraryPath propagatedNativeBuildInputs;

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/opt/trueconf/TrueConf
    patchelf --set-rpath ${libsPath}:$out/opt/trueconf/plugins/gui:$out/opt/trueconf/lib $out/opt/trueconf/TrueConf
    patchelf --set-rpath ${libsPath} $out/opt/trueconf/plugins/gui/*.so
    wrapQtApp $out/opt/trueconf/TrueConf
    wrapProgram $out/opt/trueconf/TrueConf --suffix LD_LIBRARY_PATH : ${libsPath}
  '';

  installPhase = ''
    mkdir -p $out/bin
    dpkg -x $src $out
    ln -s $out/opt/trueconf/TrueConf $out/bin/TrueConf
  '';

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  meta = with lib; {
    homepage = https://trueconf.com;
    description = "Cutting-Edge Video Conferencing Solution";
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
