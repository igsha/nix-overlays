{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.9.2";
  hash = sha256:022x364571xl2cy7pzybjmvyp6ds5nphdjwv8xlf5hb6c5dib7q3;
  inherit stdenv fetchurl;
}
