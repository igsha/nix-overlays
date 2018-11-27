{ mkShell,
  buildEnv,
  ghcWithPackages,
  docproc,
  docx-combine,
  docx-replace,
  python3,
  plantuml,
  graphviz,
  pantable,
  panflute,
  imagemagick7,
  cmake,
  gnumake,
  PandocElements,
  pandoc-pipe
}:

let
  pandocWithDeps = ghcWithPackages (p: with p; [
    pandoc-crossref
    pandoc-citeproc
    pandoc-placetable
    pandoc-include-code
  ]);

in mkShell rec {
  name = "pandocenv";
  buildInputs = [
    docx-combine
    docx-replace
    (python3.withPackages (p: [ p.python-docx panflute ]))
    pantable
    pandocWithDeps
    docproc
    cmake
    gnumake
    plantuml
    graphviz
    imagemagick7
    PandocElements
    pandoc-pipe
  ];

  env = buildEnv {
    inherit name;
    paths = buildInputs;
  };
}
