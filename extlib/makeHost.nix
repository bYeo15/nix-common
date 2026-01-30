{ sources, pkgs, lib, ... }:

let
    evalConfig = import "${toString sources.nixpkgs.outPath}/nixos/lib/eval-config.nix";
in hostModules: args: evalConfig {
    modules = hostModules;
    specialArgs = args;
}
