pkgs:

let
  fetchMaster = user-repo: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/master";
  youtube-dl-extractor = ./youtube-dl/user_extractors.py;

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

  panflute = pkgs.callPackage ./panflute { };
  pantable = pkgs.callPackage ./pantable { };
  cxxopts = pkgs.callPackage ./cxxopts { };

  youtube-dl = pkgs.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
    '';
  });

  inherit (pkgs.callPackage ./perl-packages {}) PandocElements;
  docproc = pkgs.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = pkgs.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-release = pkgs.callPackage ./pandoc/2.6.nix { };
  pandoc-release-24 = pkgs.callPackage ./pandoc/2.4.nix { };
  pandoc-crossref-release = pkgs.callPackage ./pandoc-crossref/0.3.4.0c.nix { };
  pandoc-crossref = pandoc-crossref-release;
  pandoc = pandoc-release;

  myGhc = pkgs.haskellPackages.override {
    overrides = self: super: {
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
