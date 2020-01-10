{ stdenv, fetchurl }:

import ./common.nix {
  version = "0.3.6.1b";
  hash = sha256:1lxvzsp0y0mvsnmmf3cg6srk5lf87xb9n21jf8ws08pwd221sy63;
  pandocVersion = "2_9_1_1";
  inherit stdenv fetchurl;
}
