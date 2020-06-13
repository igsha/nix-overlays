self: super:

let
  fetchBranch = user-repo: branch: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/${branch}";
  fetchMaster = user-repo: fetchBranch user-repo "master";
  youtube-dl-extractor = ./pkgs/youtube-dl/user_extractors.py;

in {
  neovim = (super.neovim.override {
    configure = import ./pkgs/vimrcConfig.nix { inherit (super) vimUtils vimPlugins fetchFromGitHub python3Packages; };
  }).overrideAttrs (old: rec {
    buildCommand = old.buildCommand + ''
      substitute $out/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
        --replace 'Exec=nvim' "Exec=termite --class editor -e nvim"
    '';
  });

  docx-combine = super.callPackage (fetchMaster "cvlabmiet/docx-combine") { };
  docx-replace = super.callPackage (fetchMaster "cvlabmiet/docx-replace") { };

  panflute = super.callPackage ./pkgs/panflute { };
  pantable = super.callPackage ./pkgs/pantable { };
  cxxopts = super.callPackage ./pkgs/cxxopts { };

  youtube-dl = (super.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
    '';
  })).override { phantomjsSupport = true; };

  inherit (super.callPackage ./pkgs/perl-packages {}) PandocElements;
  docproc = super.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = super.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-bin = super.callPackage ./pkgs/pandoc/2.9.2.nix { };
  pandoc-crossref-bin = super.callPackage ./pkgs/pandoc-crossref/0.3.6.2.nix { };

  iplay = super.callPackage (fetchMaster "igsha/iplay") { };
  clang-tools = super.clang-tools.overrideAttrs (old: {
    postInstall = ''
      ln -s $out/bin/clangd $out/bin/clang-doc
    '';
  });
  trueconf = super.callPackage ./pkgs/trueconf { };
  agola = super.callPackage ./pkgs/agola { };
  bcp = (super.boost.override { extraB2Args = [ "tools/bcp" ]; }).overrideAttrs (old: {
    installPhase = ''
      mkdir -p $out
      cp -r dist/bin $out/
    '';
    outputs = [ "out" ];
    postFixup = null;
  });
  cmake-format = super.callPackage ./pkgs/cmake-format { };
}
