#!/usr/bin/env nix-shell

{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
  buildInputs = [
    python3
    python3Packages.jinja2
  ];
}
