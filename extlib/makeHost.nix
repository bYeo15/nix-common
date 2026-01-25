{ sources, pkgs, lib, ... }:

let
    evalConfig = import "${toString sources.nixpkgs.outPath}/nixos/lib/eval-config.nix";
in host: args: lib.fix (self: evalConfig {
    modules = host;
    specialArgs = args // { inherit self; };
})
