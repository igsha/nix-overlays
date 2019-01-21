pkgs:

let
  fetchMaster = user-repo: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/master";

in rec {
  qutebrowser = pkgs.qutebrowser.overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.libGL ];
    postFixup = oldAttrs.postFixup + ''
      wrapProgram $out/bin/qutebrowser --suffix LD_LIBRARY_PATH : "${pkgs.libGL}/lib"
      sed -i 's/\.qutebrowser-wrapped/qutebrowser/' $out/bin/..qutebrowser-wrapped-wrapped
    '';
  });

  clawsMail = pkgs.clawsMail.override {
    enablePluginFancy = true;
    enablePluginVcalendar = true;
    enableSpellcheck = true;
    enablePluginRssyl = true;
    enablePluginPdf = true;
    webkitgtk24x-gtk2 = pkgs.webkitgtk;
  };

  matplotlib = pkgs.python3Packages.matplotlib.overrideAttrs (oldAttrs: rec {
    enableQt = true;
  });

  neovim = pkgs.neovim.override {
    configure = import ./vimrcConfig.nix { inherit (pkgs) vimUtils vimPlugins fetchFromGitHub; };
  };

  clang-tools = pkgs.clang-tools.override {
    llvmPackages = pkgs.llvmPackages_6;
  };

  docx-combine = import (fetchMaster "cvlabmiet/docx-combine") { inherit pkgs; };
  docx-replace = import (fetchMaster "cvlabmiet/docx-replace") { inherit pkgs; };

  panflute = pkgs.callPackage ./panflute {
    pythonPackages = pkgs.python3Packages;
  };
  pantable = pkgs.callPackage ./pantable {
    pythonPackages = pkgs.python3Packages;
    panflute = panflute;
  };

  inherit (pkgs.callPackage ./perl-packages {}) PandocElements;
  docproc = pkgs.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = pkgs.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  myGhc = pkgs.haskellPackages.override {
    overrides = self: super: {
      tasty = super.callPackage
        ({ mkDerivation, ansi-terminal, async, base, clock, containers, mtl
         , optparse-applicative, stm, tagged, unbounded-delays, unix
         , wcwidth
         }:
         mkDerivation {
           pname = "tasty";
           version = "1.1.0.4";
           sha256 = "1gzf1gqi5p78m8rc21g9a8glc69r68igxr9n4qn4bs6wqyi3ykiv";
           libraryHaskellDepends = [
             ansi-terminal async base clock containers mtl optparse-applicative
             stm tagged unbounded-delays unix wcwidth
           ];
           description = "Modern and extensible testing framework";
           license = pkgs.stdenv.lib.licenses.mit;
         }) {};

      zip-archive_0_3_3 = super.callPackage
        ({ mkDerivation, array, base, binary, bytestring, Cabal, containers
         , digest, directory, filepath, HUnit, mtl, pretty, process
         , temporary, text, time, unix, unzip, zlib
         }:
         mkDerivation {
           pname = "zip-archive";
           version = "0.3.3";
           sha256 = "0kf8xyac168bng8a0za2jwrbss7a4ralvci9g54hnvl0gkkxx2lq";
           isLibrary = true;
           isExecutable = true;
           setupHaskellDepends = [ base Cabal ];
           libraryHaskellDepends = [
             array base binary bytestring containers digest directory filepath
             mtl pretty text time unix zlib
           ];
           testHaskellDepends = [
             base bytestring directory filepath HUnit process temporary time
             unix
           ];
           testToolDepends = [ unzip ];
           description = "Library for creating and modifying zip archives";
           license = pkgs.stdenv.lib.licenses.bsd3;
         }) {inherit (pkgs) unzip;};

      pandoc_2_4 = super.callPackage
      ({ mkDerivation, aeson, aeson-pretty, base, base64-bytestring
       , binary, blaze-html, blaze-markup, bytestring, Cabal
       , case-insensitive, cmark-gfm, containers, criterion, data-default
       , deepseq, Diff, directory, doctemplates, exceptions
       , executable-path, filepath, Glob, haddock-library, hslua
       , hslua-module-text, HsYAML, HTTP, http-client, http-client-tls
       , http-types, JuicyPixels, mtl, network, network-uri, pandoc-types
       , parsec, process, QuickCheck, random, safe, SHA, skylighting
       , split, syb, tagsoup, tasty, tasty-golden, tasty-hunit
       , tasty-quickcheck, temporary, texmath, text, time
       , unicode-transforms, unix, unordered-containers, vector, weigh
       , xml, zip-archive, zlib
       }:
       mkDerivation {
         pname = "pandoc";
         version = "2.4";
         sha256 = "1kf1v7zfifh5i1hw5bwdbd78ncp946kx1s501c077vwzdzvcz2ck";
         configureFlags = [ "-fhttps" "-f-trypandoc" ];
         isLibrary = true;
         isExecutable = true;
         enableSeparateDataOutput = true;
         setupHaskellDepends = [ base Cabal ];
         libraryHaskellDepends = [
           aeson aeson-pretty base base64-bytestring binary blaze-html
           blaze-markup bytestring case-insensitive cmark-gfm containers
           data-default deepseq directory doctemplates exceptions filepath
           Glob haddock-library hslua hslua-module-text HsYAML HTTP
           http-client http-client-tls http-types JuicyPixels mtl network
           network-uri pandoc-types parsec process random safe SHA skylighting
           split syb tagsoup temporary texmath text time unicode-transforms
           unix unordered-containers vector xml zip-archive zlib
         ];
         executableHaskellDepends = [ base ];
         testHaskellDepends = [
           base base64-bytestring bytestring containers Diff directory
           executable-path filepath Glob hslua pandoc-types process QuickCheck
           tasty tasty-golden tasty-hunit tasty-quickcheck temporary text time
           xml zip-archive
         ];
         benchmarkHaskellDepends = [
           base bytestring containers criterion mtl text time weigh
         ];
         doCheck = false;
         description = "Conversion between markup formats";
         license = pkgs.stdenv.lib.licenses.gpl2;
         hydraPlatforms = pkgs.stdenv.lib.platforms.none;
       }) { zip-archive = self.zip-archive_0_3_3; };

      pandoc-crossref = super.pandoc-crossref.override { pandoc = self.pandoc_2_4; };
      pandoc-include-code = super.pandoc-include-code.overrideAttrs (old: rec { doCheck = false; });
      conduit = super.conduit.overrideAttrs (old: rec { doCheck = false; });
    };
  };

  pandocenv = pkgs.callPackage ./envs/pandoc.nix { inherit (myGhc) ghcWithPackages; };
  gccenv = pkgs.callPackage ./envs/gcc.nix pkgs;
  pythonenv = pkgs.callPackage ./envs/python.nix pkgs;
  latexenv = pkgs.callPackage ./envs/latex.nix pkgs;
  luaenv = pkgs.callPackage ./envs/lua.nix pkgs;
}
