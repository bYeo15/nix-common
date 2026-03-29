let
    resources = import ./resources;
in {
    # Context-agnostic extension to the standard libraries
    extlib = { sources, pkgs, lib, ... }: import ./extlib { inherit sources; inherit pkgs; inherit lib; };

    # Extension to nixpkgs
    extpkgs = { pkgs, lib, ... }: import ./extpkgs { inherit pkgs lib; };


    data = [
        ./data_modules
    ] ++ resources.sharedResources;

    home = [
        ./renix
        ./scripts
    ] ++ resources.homeResources;

    nixos = [

    ] ++ resources.nixosResources;
}
