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

  myGhc = pkgs.haskell.packages.ghc844.override {
    overrides = self: super: {
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
       }) {};

      pandoc-crossref = super.pandoc-crossref.override { pandoc = self.pandoc; };
      pandoc-citeproc = super.pandoc-citeproc.override { pandoc = self.pandoc; };
      pandoc-include-code = super.pandoc-include-code.overrideAttrs (old: rec { doCheck = false; });
      pandoc = self.pandoc_2_4.override {
        haddock-library = super.haddock-library_1_7_0;
        hslua = super.hslua_1_0_1;
        hslua-module-text = super.hslua-module-text_0_2_0.override { hslua = super.hslua_1_0_1; };
      };
    };
  };

  pandocenv = pkgs.callPackage ./envs/pandoc.nix { inherit (myGhc) ghcWithPackages; };
  gccenv = pkgs.callPackage ./envs/gcc.nix pkgs;
  pythonenv = pkgs.callPackage ./envs/python.nix pkgs;
  latexenv = pkgs.callPackage ./envs/latex.nix pkgs;
  luaenv = pkgs.callPackage ./envs/lua.nix pkgs;
}
