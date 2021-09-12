{ stdenv, lib, fetchurl, dpkg, patchelf, curl, freetype, libidn, gcc, alsaLib, glib, glibc,
libpulseaudio, libv4l, boost16x, libudev, gnupg, cppdb, speex, speexdsp, icu67, zeromq,
protobuf3_12, xorg, qt5, libGL, openssl, dbus, makeWrapper
}:

let
  libidn11 = libidn.overrideAttrs (old: rec {
    name = "libidn-1.34";
    src = fetchurl {
      url = "mirror://gnu/libidn/${name}.tar.gz";
      hash = sha256:0g3fzypp0xjcgr90c5cyj57apx1cmy0c6y9lvw2qdcigbyby469p;
    };
  });
  protobuf = protobuf3_12;
  icu = icu67;

in stdenv.mkDerivation rec {
  pname = "trueconf";
  version = "7.5.3.721";

  src = fetchurl {
    url = https://trueconf.com/download/trueconf_client_ubuntu2104_amd64.deb?v=202106251500;
    hash = sha256:1cya0g4nd172wqrlksvaz4kpzwynmgjxk1z6hrm7fshnql879784;
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
