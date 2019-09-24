{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.4";
  sha256 = "1sm97rnhy3v0mp6mcybxn5p7qdb10q29zvhd8kvknrcsck7lscv4";
  inherit stdenv fetchurl;
}
