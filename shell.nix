{ pkgs ? import <nixpkgs> {} }:
let
  avr-cc = pkgs.pkgsCross.avr.buildPackages.gcc;
  avr-binutils = pkgs.pkgsCross.avr.buildPackages.binutils;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    avr-cc
    avr-binutils
    avrdude
    clang-tools
  ];
}
