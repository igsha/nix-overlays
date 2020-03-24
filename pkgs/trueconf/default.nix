{ stdenv, fetchurl, dpkg, patchelf, curl, freetype, libidn, gcc, alsaLib, glib, glibc,
libpulseaudio, libv4l, boost167, libudev, gnupg, cppdb, speex, speexdsp, icu63, zeromq,
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
  icu = icu63;

in stdenv.mkDerivation rec {
  pname = "trueconf";
  version = "7.5.0.246";

  src = fetchurl {
    url = "https://trueconf.com/download/trueconf_client_ubuntu1910_amd64.deb";
    hash = sha256:1vckzl8lr1ixx3j6n2c4mmw5m633xagy6arj9ds18k7113ha761v;
  };

  nativeBuildInputs = [ dpkg patchelf qt5.wrapQtAppsHook makeWrapper ];
  propagatedNativeBuildInputs = [
    stdenv.cc.cc
    glib
    glibc
    curl
    alsaLib
    libpulseaudio
    boost167
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
  libsPath = stdenv.lib.makeLibraryPath propagatedNativeBuildInputs;

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/opt/trueconf/TrueConf
    patchelf --set-rpath ${libsPath}:$out/opt/trueconf/plugins/gui $out/opt/trueconf/TrueConf
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

  meta = with stdenv.lib; {
    homepage = https://trueconf.com;
    description = "Cutting-Edge Video Conferencing Solution";
    platform = platforms.linux;
    maintainer = maintainers.igsha;
  };
}
