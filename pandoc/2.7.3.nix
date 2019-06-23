{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.7.3";
  sha256 = sha256:192wxd7519zd6whka6bqbhlgmkzmwszi8fgd39hfr8cz78bc8whc;
  inherit stdenv fetchurl;
}
