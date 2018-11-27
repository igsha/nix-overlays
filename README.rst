About
=====

Provides new packages and package customizations for nixpkgs.

Configuration
=============

Place this in ``nix.conf`` (create link on directory or use url)::

  packageOverrides = let my-packages = /etc/nix-overrides; in
    if builtins.pathExists my-packages
    then import my-packages
    else import (builtins.fetchTarball https://api.github.com/repos/igsha/nix-overrides/tarball/master);

Use new package and overrides in ``configuration.nix``::

  nixpkgs.config = import ./nixpkgs-config.nix;

  system.extraDependencies = with pkgs; [
    gccenv.env
    pandocenv.env
    pythonenv.env
    ...
  ];

  environment.systemPackages = with pkgs; [
    panflute
    qutebrowser
    docproc
    ...
