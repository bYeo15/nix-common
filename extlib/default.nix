{ sources, pkgs, lib, ... } @ moduleArgs:

{
    filterTagged = import ./filterTagged.nix { inherit lib; };
    extractAttr = import ./extractAttr.nix { inherit lib; };
    withDefault = import ./withDefault.nix { inherit lib; };

    makeHome = import ./makeHome.nix moduleArgs;
    makeHost = import ./makeHost.nix moduleArgs;
}
