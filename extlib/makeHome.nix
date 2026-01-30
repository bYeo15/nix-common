{ sources, pkgs, lib, ... }:

let
    evalHome = import "${toString sources.home-manager.outPath}/modules/default.nix";
    consolidateModules = modules: { ... }: {
        imports = modules;
    };
in userModules: args: evalHome {
    inherit pkgs;
    configuration = consolidateModules userModules;
    extraSpecialArgs = args;
}
