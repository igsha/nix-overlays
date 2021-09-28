self: super:

let
  fetchBranch = user-repo: branch: builtins.fetchTarball "https://api.github.com/repos/${user-repo}/tarball/${branch}";
  fetchMaster = user-repo: fetchBranch user-repo "master";
  youtube-dl-extractor = ./pkgs/youtube-dl/user_extractors.py;

in {
  docx-combine = super.callPackage (fetchMaster "cvlabmiet/docx-combine") { };
  docx-replace = super.callPackage (fetchMaster "cvlabmiet/docx-replace") { };

  panflute = super.callPackage ./pkgs/panflute { };
  pantable = super.callPackage ./pkgs/pantable { };
  cxxopts = super.callPackage ./pkgs/cxxopts { };

  youtube-dl = (super.youtube-dl.overrideAttrs (old: rec {
    postPatch = ''
      cp ${youtube-dl-extractor} youtube_dl/extractor/user_extractors.py
      echo "from .user_extractors import *" >> youtube_dl/extractor/extractors.py
      sed -i '/YandexDiskIE/d' youtube_dl/extractor/extractors.py
    '';
  })).override { phantomjsSupport = true; };

  inherit (super.callPackage ./pkgs/perl-packages {}) PandocElements;
  docproc = super.callPackage (fetchMaster "igsha/docproc") { };
  pandoc-pipe = super.callPackage (fetchMaster "igsha/pandoc-pipe") { };

  pandoc-bin = super.callPackage ./pkgs/pandoc/2.14.nix { };
  pandoc-crossref-bin = super.callPackage ./pkgs/pandoc-crossref/0.3.11.0.nix { };

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
  i3blocks-gaps = super.i3blocks-gaps.overrideAttrs (old: {
    postPatch = ''
      sed -i 's|perl |${super.lib.makeBinPath [ super.perl ]}/perl |g' ./scripts/volume
    '';
  });

  python3 = super.python3.override {
    packageOverrides = pself: psuper: {
      jupyterhub = psuper.jupyterhub.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  };

  udevil = super.udevil.overrideAttrs (old: {
    postInstall = ''
      sed -i 's/^allowed_types =.*/allowed_types = \$KNOWN_FILESYSTEMS, file, cifs, nfs, curlftpfs, ftpfs, sshfs, davfs/' \
        $out/etc/udevil/udevil.conf
    '';
  });
}
