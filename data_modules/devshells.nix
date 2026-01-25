{ config, lib, pkgs, ... }:

let
    devshell = with lib; with types; submodule {
        options = {
            template = mkOption {
                type = path;
                description = "Path to the devshell template";
            };
            hook = mkOption {
                type = str;
                description = "Sequence of bash commands to execute when loading the devshell";
                default = "";
            };
        };
    };
in {
    options = with lib; with types; {
        devshells = mkOption {
            type = attrsOf (devshell);
            description = "A set of available devshells";
            default = { };
        };
    };
}
