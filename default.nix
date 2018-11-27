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
      "haddock-library_1_6_1" = super.callPackage
        ({ mkDerivation, base, base-compat, bytestring, containers, deepseq
         , directory, filepath, hspec, hspec-discover, optparse-applicative
         , QuickCheck, transformers, tree-diff
         }:
         mkDerivation {
           pname = "haddock-library";
           version = "1.6.1";
           sha256 = "195fhaxr0c652icnd325jvzbi0anr2zlwyfjpl0dyn68v38apn5n";
           libraryHaskellDepends = [
             base bytestring containers deepseq transformers
           ];
           testHaskellDepends = [
             base base-compat bytestring containers deepseq directory filepath
             hspec optparse-applicative QuickCheck transformers tree-diff
           ];
           testToolDepends = [ hspec-discover ];
           doHaddock = false;
           description = "Library exposing some functionality of Haddock";
           license = pkgs.stdenv.lib.licenses.bsd3;
           hydraPlatforms = pkgs.stdenv.lib.platforms.none;
         }) {};
      /*pandoc = super.pandoc_2_3_1.override {
        haddock-library = self.haddock-library_1_6_1;
        hslua = super.hslua_1_0_1;
        hslua-module-text = super.hslua-module-text_0_2_0.override { hslua = super.hslua_1_0_1; };
      };*/
      pandoc-crossref = super.pandoc-crossref.override { pandoc = self.pandoc; };
      pandoc-citeproc = super.pandoc-citeproc.override { pandoc = self.pandoc; };
      pandoc-include-code = super.pandoc-include-code.overrideAttrs (old: rec { doCheck = false; });
      pandoc = super.pandoc_2_4.override {
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
