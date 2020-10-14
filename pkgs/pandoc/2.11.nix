{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.11";
  hash = sha256:1rm2w4sv80gsny45vhg9m1l6j9031b4qim6w8jh3zxkpb7rhm8z6;
  inherit stdenv fetchurl;
}
