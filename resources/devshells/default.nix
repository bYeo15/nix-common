{ config, lib, pkgs, ... }:

{
    config.devshells = {
        default = {
            template = ./emptyShell.nix;
        };

        python = {
            template = ./pythonShell.nix;
        };

        c = {
            template = ./cShell.nix;
        };
    };
}
