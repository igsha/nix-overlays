{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.9.1.1";
  hash = sha256:1r9qqi1am6zvw7sdpasgip9fykdwqchvlb51sl8r4jyjbr2v5zw0;
  inherit stdenv fetchurl;
}
