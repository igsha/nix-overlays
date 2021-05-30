{ stdenv, fetchurl, lib }:

import ./common.nix {
  version = "2.14";
  hash = sha256:1303wsr31ac1ap37m27ghr3azgdw3j39d8i80ilpv40x4iywlk72;
  inherit stdenv fetchurl lib;
}
