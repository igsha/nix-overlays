{ stdenv, fetchurl }:

import ./common.nix {
  version = "0.3.6.2";
  hash = sha256:0hzyl1hf5kp77dlspzhcjg7vd64ik6cqpvcywx6cypmmhxs2j54g;
  pandocVersion = "2_9_2";
  inherit stdenv fetchurl;
}
