{ stdenv, fetchurl, lib }:

import ./common.nix {
  version = "0.3.11.0";
  hash = sha256:0pjzrnvbd57ai40z2s711b4qw1cphx5ksrajmfw616lhbnvl39zc;
  inherit stdenv fetchurl lib;
}
