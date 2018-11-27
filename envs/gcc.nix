pkgs:

with pkgs;
let
  compiling = [ clang-tools pkgconfig cmake gnumake dpkg rpm ];
  debugging = [ gdb valgrind strace ltrace binutils lcov ];
  documenting = [ doxygen graphviz plantuml ];
  testing = [ catch gtest ];
  image = [ cimg pngpp libjpeg netpbm SDL SDL_image imagemagick7 ];
  generic = [ boost openmpi ];
  huge = [ ffmpeg opencv3 ncurses sfml ];

in pkgs.mkShell rec {
  name = "gccenv";
  buildInputs = [
    libxslt
    libxml2
    zlib
    readline
    bison
    flex
    fuse3
  ] ++ testing ++ image ++ generic ++ huge;

  nativeBuildInputs = [ gcc8 ] ++ debugging ++ documenting ++ compiling;

  hardeningDisable = [ "all" ];

  env = buildEnv {
    inherit name;
    paths = buildInputs ++ nativeBuildInputs;
  };
}
