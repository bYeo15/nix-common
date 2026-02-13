{ pkgs, ... }:

{
    glbg = pkgs.callPackage (import ./glbg.nix) { };
}
