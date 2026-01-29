{ sources, pkgs, lib, ... }:

let
    evalConfig = import "${toString sources.nixpkgs.outPath}/nixos/lib/eval-config.nix";
in host: args: evalConfig {
    modules = [ host ];
    specialArgs = args;
}
