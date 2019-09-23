self: super:

let
  fetchBranch = user-repo: branch: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/${branch}";
  fetchMaster = user-repo: fetchBranch user-repo "master";
  youtube-dl-extractor = ./youtube-dl/user_extractors.py;

in {
  neovim = (super.neovim.override {
    configure = import ./vimrcConfig.nix { inherit (super) vimUtils vimPlugins fetchFromGitHub; };
  }).overrideAttrs (old: rec {
    buildCommand = old.buildCommand + ''
      substitute $out/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
        --replace 'Exec=nvim' "Exec=xst -c editor -e nvim "
    '';
  });

  docx-combine = super.callPackage (fetchMaster "cvlabmiet/docx-combine") { };
  docx-replace = super.callPackage (fetchMaster "cvlabmiet/docx-replace") { };

  panflute = super.callPackage ./panflute { };
  pantable = super.callPackage ./pantable { };
  cxxopts = super.callPackage ./cxxopts { };

  youtube-dl = (super.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
    '';
  })).override { phantomjsSupport = true; };

  inherit (super.callPackage ./perl-packages {}) PandocElements;
  docproc = super.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = super.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-release = super.callPackage ./pandoc/2.7.3.nix { };
  pandoc-crossref-release = super.callPackage ./pandoc-crossref/0.3.4.0d.nix { };
  pandoc = self.pandoc-release;
  pandoc-crossref = self.pandoc-crossref-release;

  iplay = super.callPackage (fetchMaster "igsha/iplay") { };
}
