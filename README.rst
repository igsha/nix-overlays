About
=====

Provides new packages and package customizations for nixpkgs.

Configuration
=============

Use new package and overrides in ``configuration.nix``::

  let
    overlay = https://api.github.com/repos/igsha/nix-overlays/tarball/master;
  ...

  nixpkgs.overlays = [ (import overlay) ];
  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=${overlay}/overlays.nix" ];

  system.extraDependencies = with pkgs; [
    docproc
    iplay
    ...
  ];

  environment.systemPackages = with pkgs; [
    panflute
    qutebrowser
    docproc
    ...

Setting of ``nixpkgs.overlays`` allows to use overlays through system and
``nix.nixPath`` allows to user overlays through nix tools.
