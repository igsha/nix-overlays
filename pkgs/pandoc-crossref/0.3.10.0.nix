{ stdenv, fetchurl, lib }:

import ./common.nix {
  version = "0.3.10.0";
  hash = sha256:1aallgcn7ri0xc7vd3dp60cdnf19aq1snvx2yw3l4rfbm26wqlf8;
  inherit stdenv fetchurl lib;
}
