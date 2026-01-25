{ config, lib, pkgs, ... }:

{
    options = with lib; with types; {
        ageSecretFiles = mkOption {
            type = attrsOf (path);
            description = "A set of named paths to secret files";
            default = { };
        };
    };
}
