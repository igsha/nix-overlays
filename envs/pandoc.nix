{ mkShell,
  buildEnv,
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
  pandoc-pipe,
  pandoc,
  pandoc-crossref,
  pandoc-placetable
}:

mkShell rec {
  name = "pandocenv";
  buildInputs = [
    docx-combine
    docx-replace
    (python3.withPackages (p: [ p.python-docx panflute ]))
    pantable
    docproc
    cmake
    gnumake
    plantuml
    graphviz
    imagemagick7
    PandocElements
    pandoc-pipe
    pandoc-placetable
    pandoc
    pandoc-crossref
  ];

  env = buildEnv {
    inherit name;
    paths = buildInputs;
  };
}
