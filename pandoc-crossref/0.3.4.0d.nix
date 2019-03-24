{ stdenv, fetchurl }:

import ./common.nix {
  version = "0.3.4.0d";
  sha256 = "086g097ndm186qyvw523wfy2pa3gy5zrl8b0cbi76zcwqhj048ld";
  pandocVersion = "2_7";
  inherit stdenv fetchurl;
}
