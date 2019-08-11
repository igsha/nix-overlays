pkgs:

let
  fetchBranch = user-repo: branch: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/${branch}";
  fetchMaster = user-repo: fetchBranch user-repo "master";
  youtube-dl-extractor = ./youtube-dl/user_extractors.py;

in rec {
  clawsMail = pkgs.clawsMail.override {
    enablePluginFancy = true;
    enablePluginVcalendar = true;
    enableSpellcheck = true;
    enablePluginRssyl = true;
    enablePluginPdf = true;
    webkitgtk24x-gtk2 = pkgs.webkitgtk;
  };

  neovim = pkgs.neovim.override {
    configure = import ./vimrcConfig.nix { inherit (pkgs) vimUtils vimPlugins fetchFromGitHub; };
  };

  clang-tools = pkgs.clang-tools.override {
    llvmPackages = pkgs.llvmPackages_7;
  };

  docx-combine = import (fetchMaster "cvlabmiet/docx-combine") { inherit pkgs; };
  docx-replace = import (fetchMaster "cvlabmiet/docx-replace") { inherit pkgs; };

  panflute = pkgs.callPackage ./panflute { };
  pantable = pkgs.callPackage ./pantable { };
  cxxopts = pkgs.callPackage ./cxxopts { };

  youtube-dl = (pkgs.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
    '';
  })).override { phantomjsSupport = true; };

  inherit (pkgs.callPackage ./perl-packages {}) PandocElements;
  docproc = pkgs.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = pkgs.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-release = pkgs.callPackage ./pandoc/2.7.3.nix { };
  pandoc-crossref-release = pkgs.callPackage ./pandoc-crossref/0.3.4.0d.nix { };
  pandoc = pandoc-release;
  pandoc-crossref = pandoc-crossref-release;

  iplay = pkgs.callPackage (fetchMaster "igsha/iplay") { };

  pandocenv = pkgs.callPackage ./envs/pandoc.nix { inherit (pkgs.haskellPackages) pandoc-placetable; };
  gccenv = pkgs.callPackage ./envs/gcc.nix pkgs;
  pythonenv = pkgs.callPackage ./envs/python.nix pkgs;
  latexenv = pkgs.callPackage ./envs/latex.nix pkgs;
  luaenv = pkgs.callPackage ./envs/lua.nix pkgs;
}
