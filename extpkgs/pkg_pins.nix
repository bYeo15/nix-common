{ pkgs, lib, ... }:

let
    sources = import ./npins;
    exclude = [ "__functor" ];
in lib.mapAttrs (n: v: pkgs.callPackage (import v) { }) (lib.removeAttrs sources exclude)
