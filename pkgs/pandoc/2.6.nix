{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.6";
  sha256 = "1cvsr71dqh6hmwf67w45hr6rshsj5hsfj083kjl51ymhn3gbsh2g";
  inherit stdenv fetchurl;
}
