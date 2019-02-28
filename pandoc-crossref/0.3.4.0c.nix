{ stdenv, fetchurl }:

import ./common.nix {
  version = "0.3.4.0c";
  sha256 = "1klafpjrq4qp6r73fasn4g7047pasc81dgz4yd823c4jd1zv8zzv";
  pandocVersion = "2_6";
  inherit stdenv fetchurl;
}
