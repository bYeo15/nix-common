{
    # Context-agnostic extension to the standard libraries
    extlib = { sources, pkgs, lib, ... }: import ./extlib { inherit sources; inherit pkgs; inherit lib; };

    data = [
        ./data_modules
    ];

    home = [
        ./renix
    ];

    nixos = [

    ];
}
