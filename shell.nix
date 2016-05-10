{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "minikrebs-env";
  version = "1.1";
  buildInputs = with pkgs; [
    wget
    subversion
    gcc
    git
    gawk
    openssl
    bash
    which
    qemu
  ];
  shellHook = ''
    HISTFILE=$PWD/.histfile
  '';
}
