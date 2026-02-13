let
    resources = import ./resources;
in {
    # Context-agnostic extension to the standard libraries
    extlib = { sources, pkgs, lib, ... }: import ./extlib { inherit sources; inherit pkgs; inherit lib; };
    extpkgs = { pkgs, ... }: import ./extpkgs { inherit pkgs; };


    data = [
        ./data_modules
    ] ++ resources.sharedResources;

    home = [
        ./renix
    ] ++ resources.homeResources;

    nixos = [

    ] ++ resources.nixosResources;
}
