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

    # contains the program clangd which is a LSP server for C
    clang-tools

    # tool for generating compile_commands.json needed by clangd
    bear

    # used to add avr include paths to compile_commands.json
    jq
  ];
}
