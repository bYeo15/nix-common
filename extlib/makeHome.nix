{ sources, pkgs, lib, ... }:

let
    evalHome = import "${toString sources.home-manager.outPath}/modules/default.nix";
in user: args: evalHome {
    inherit pkgs;
    configuration = user;
    extraSpecialArgs = args;
}
