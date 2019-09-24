About
=====

Provides new packages and package customizations for nixpkgs.

Configuration
=============

Set up overlay in ``~/.config/nixpkgs/overlays.nix``::

   let
     url = https://api.github.com/repos/igsha/nix-overlays/tarball/master;
     overlay = builtins.fetchTarball url;
   in [
      (import overlay)
   ]

To use overlay through the whole system, put these lines into ``configuration.nix``::

  let
    overlay = builtins.fetchTarball https://api.github.com/repos/igsha/nix-overlays/tarball/master;
  ...

  nixpkgs.overlays = [ (import overlay) ];

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

You should use both approach: one is for nix tools, another is for system only needs.
