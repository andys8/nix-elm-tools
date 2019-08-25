# This file has been generated by node2nix 1.7.0. Do not edit!

{pkgs ? import <nixpkgs> {
    inherit system;
  }, system ? builtins.currentSystem, nodejs ? pkgs."nodejs-10_x"}:

let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
in
import ./packages.nix {
  inherit (pkgs) fetchurl fetchgit;
  inherit nodeEnv;
}