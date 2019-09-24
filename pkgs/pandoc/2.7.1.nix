{ stdenv, fetchurl }:

import ./common.nix {
  version = "2.7.1";
  sha256 = sha256:09w3c6h5hm6cn79hgrwhpn9hrwhckri11xq0rzjq5rxd9ybmx467;
  inherit stdenv fetchurl;
}
