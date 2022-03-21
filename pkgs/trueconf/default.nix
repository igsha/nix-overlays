{ stdenv, lib, fetchurl, dpkg, patchelf, curl, freetype, libidn, gcc, alsaLib, glib, glibc,
libpulseaudio, libv4l, udev, gnupg, cppdb, speex, speexdsp, icu67, zeromq, sqlite,
protobuf3_12, xorg, qt5, qt5Full, libGL, openssl, dbus, makeWrapper, lame, ghostscript
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
    url = https://trueconf.com/download/trueconf_client_ubuntu2010_amd64.deb?v=202103221900;
    hash = "sha256-xYDA6z4ghxT1aD5kQUcABr+7aY9Q65gXd1sDphw62zs=";
  };

  nativeBuildInputs = [ dpkg patchelf qt5.wrapQtAppsHook makeWrapper ];
  propagatedNativeBuildInputs = [
    stdenv.cc.cc
    glib
    glibc
    curl
    alsaLib
    libpulseaudio
    libv4l
    udev
    freetype
    libidn11
    openssl
    dbus
    sqlite

    gnupg
    speex
    speexdsp
    zeromq
    cppdb
    icu
    protobuf
    lame
    ghostscript

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

    qt5Full
    libGL
  ];
  libsPath = lib.makeLibraryPath propagatedNativeBuildInputs;

  fixupPhase = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/TrueConf
    patchelf --set-rpath ${libsPath}:$out/opt/trueconf/plugins/gui:$out/lib $out/bin/TrueConf
    patchelf --set-rpath ${libsPath} $out/opt/trueconf/plugins/gui/*.so

    wrapQtApp $out/bin/TrueConf
    wrapProgram $out/bin/TrueConf --suffix LD_LIBRARY_PATH : ${libsPath}
    makeWrapper $out/bin/TrueConf $out/bin/TrueConfX11 --set XDG_SESSION_TYPE x11
  '';

  installPhase = ''
    mkdir -p $out/bin
    dpkg -x $src $out
    mv $out/opt/trueconf/TrueConf $out/bin/TrueConf
    mv $out/opt/trueconf/lib $out/
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
