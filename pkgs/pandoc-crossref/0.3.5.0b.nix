{ stdenv, fetchurl }:

import ./common.nix {
  version = "0.3.5.0b";
  hash = sha256:0fi37ll3v61cgg31s6jzhzm4c5qc0n09bs14796ikyjggf1sm2r3;
  pandocVersion = "2_8_1";
  inherit stdenv fetchurl;
}
