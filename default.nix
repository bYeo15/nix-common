let
    resources = import ./resources;
    overlays = import ./overlays;
in {
    # Context-agnostic extension to the standard libraries
    extlib = { sources, pkgs, lib, ... }: import ./extlib { inherit sources; inherit pkgs; inherit lib; };

    # Extension to nixpkgs
    extpkgs = { pkgs, lib, ... }: import ./extpkgs { inherit pkgs lib; };

    inherit overlays;

    inject_overlays = ({ config, pkgs, lib, ... }: {
        nixpkgs.overlays = overlays;
    });

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
