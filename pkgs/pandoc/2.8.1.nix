{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.8.1";
  hash = sha256:1ppsqnadsb3lk0bmka851wz6gddxh9pjsrs2bmii1xgmkxbd89xv;
  inherit stdenv fetchurl;
}
