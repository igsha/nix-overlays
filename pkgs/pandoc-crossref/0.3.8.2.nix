{ stdenv, fetchurl, lib }:

import ./common.nix {
  version = "0.3.8.2";
  hash = sha256:0nxs09jhahf7v1ffgyjpjjdgdp8j9qv9fh0xkw3q46cz1m6szk5k;
  inherit stdenv fetchurl lib;
}
