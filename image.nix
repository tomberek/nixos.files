{ pkgs ? import <nixpkgs> {} }:

let
  # Contents attributes are not on stable yet, so we temporarily vendor make-disk-image.
  # Use this line instead when 21.05 is out:
  #makeDiskImage = import "${pkgs.path}/nixos/lib/make-disk-image.nix";
  makeDiskImage = pkgs.nixos;
  # makeDiskImage = import (pkgs.fetchurl {
  #   url = "https://github.com/NixOS/nixpkgs/raw/6f21ae7a626cee022f5c20eacaaf934281e806c0/nixos/lib/make-disk-image.nix";
  #   sha256 = "0ggx659i9grw3pzjmpklspp4h3b9dywcjdyh00gjxfvrylyf4qn9";
  # });
  #evalConfig = import "${pkgs.path}/nixos/lib/eval-config.nix";
  evalConfig = pkgs.lib.evalModules;
  config = (evalConfig {
    modules = [ (import ./qemu-system-configuration.nix) ];
  }).config;
in
  makeDiskImage {
    inherit pkgs config;
    lib = pkgs.lib;
    diskSize = 16000;
    format = "qcow2-compressed";
    contents = [{
      source = pkgs.writeText "gitconfig" ''
        [user]
          name = builds.sr.ht
          email = builds@sr.ht
      '';
      target = "/home/build/.gitconfig";
      user = "build";
      group = "users";
      mode = "644";
    }];
  }

