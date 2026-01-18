{ inputs, config, lib, pkgs, ... }:

{
    imports = [
        { _module.args = { extlib = import ./extlib { inherit lib; }; }; }
        ./data_modules
        ./renix
    ];
}
