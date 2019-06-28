{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.7.3";
  sha256 = sha256:0xfvmfw1yn72iiy52ia7sk6hgrvn62qwkw009l02j0y55va5yxzb;
  inherit stdenv fetchurl;
}
